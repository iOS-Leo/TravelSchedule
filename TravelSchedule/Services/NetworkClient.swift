//
//  NetworkClient.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.08.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - API Constants

enum APIConstants {
    static let apiKey = "da376864-7e73-417e-946b-aee48bb51b36"
    static let baseURL = "https://api.rasp.yandex.net"
}

// MARK: - App Data Models

struct CityModel: Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let stations: [StationModel]
}

struct StationModel: Sendable, Identifiable, Hashable {
    let id: String
    let name: String
    let cityName: String
}

struct CarrierRouteModel: Sendable, Identifiable {
    let id = UUID()
    
    let carrierName: String
    let carrierLogoURL: String?
    let hasTransfer: Bool
    
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let date: String
    let carrierCode: String
    
    var departureHour: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if let date = formatter.date(from: departureTime) {
            return Calendar.current.component(.hour, from: date)
        }
        
        let components = departureTime.components(separatedBy: ":")
        if let first = components.first, let hour = Int(first) {
            return hour
        }
        
        return 0
    }
}

// MARK: - Network Error

enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}

// MARK: - Carrier Models

struct CarrierInfoResponse: Decodable, Sendable {
    let carrier: CarrierInfo?
    let carriers: [CarrierInfo]?
}

struct CarrierInfo: Decodable, Sendable {
    let code: Int?
    let title: String?
    let contacts: String?
    let url: String?
    let phone: String?
    let logo: String?
    let email: String?
    let address: String?
    let codes: CarrierCodes?
}

struct CarrierCodes: Decodable, Sendable {
    let icao: String?
    let sirena: String?
    let iata: String?
}

// MARK: - NetworkClient

actor NetworkClient {
    private let client: Client
    private let apiKey: String
    private let jsonDecoder = JSONDecoder()
    
    // MARK: - Init
    
    init(
        client: Client = Client(
            serverURL: try! URL(string: APIConstants.baseURL)!,
            configuration: Configuration(
                dateTranscoder: FlexibleDateTranscoder()
            ),
            transport: URLSessionTransport()
        ),
        apiKey: String = APIConstants.apiKey
    ) {
        self.client = client
        self.apiKey = apiKey
    }
    
    // MARK: - All stations
    
    func getRussianCitiesAndStations() async throws -> [CityModel] {
        let response = try await client.getAllStations(
            query: .init(
                apikey: apiKey,
                lang: "ru_RU",
                format: "json"
            )
        )
        
        switch response {
        case .ok(let okResponse):
            let limit = 50 * 1024 * 1024
            let htmlBody = try await okResponse.body.html
            let fullData = try await Data(collecting: htmlBody, upTo: limit)
            
            let allStations = try jsonDecoder.decode(
                Components.Schemas.AllStationsResponse.self,
                from: fullData
            )
            
            guard let countries = allStations.countries else { return [] }
            
            let russia = countries.first { country in
                country.title?.lowercased().contains("россия") == true
            }
            
            guard let regions = russia?.regions else { return [] }
            
            var resultCities: [CityModel] = []
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                
                for settlement in settlements {
                    guard
                        let cityName = settlement.title,
                        let cityCode = settlement.codes?.yandex_code,
                        !cityName.isEmpty
                    else {
                        continue
                    }
                    
                    let parsedStations: [StationModel] = (settlement.stations ?? []).compactMap { station in
                        guard
                            let stationName = station.title,
                            let stationCode = station.codes?.yandex_code ?? station.code,
                            !stationCode.isEmpty
                        else {
                            return nil
                        }
                        
                        return StationModel(
                            id: stationCode,
                            name: stationName,
                            cityName: cityName
                        )
                    }
                    
                    if !parsedStations.isEmpty {
                        resultCities.append(
                            CityModel(
                                id: cityCode,
                                name: cityName,
                                stations: parsedStations
                            )
                        )
                    }
                }
            }
            
            return resultCities.sorted { $0.name < $1.name }
            
        case .undocumented(let statusCode, _):
            throw NetworkError.httpError(statusCode: statusCode)
        }
    }
    
    // MARK: - Search schedule
    
    func searchSchedule(
        from: String,
        to: String,
        date: String? = nil,
        transfers: Bool = true
    ) async throws -> [CarrierRouteModel] {
        
        let response = try await client.getSchedualBetweenStations(
            query: .init(
                apikey: apiKey,
                from: from,
                to: to,
                format: "json",
                lang: "ru_RU",
                date: date,
                transfers: transfers
            )
        )
        
        switch response {
        case .ok(let okResponse):
            let jsonBody = try await okResponse.body.json
            let segments = jsonBody.segments ?? []
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return segments.map { seg in
                let depDate = seg.departure
                let arrDate = seg.arrival
                
                let depTimeString = depDate != nil ? timeFormatter.string(from: depDate!) : "--:--"
                let arrTimeString = arrDate != nil ? timeFormatter.string(from: arrDate!) : "--:--"
                let dateString = depDate != nil ? dateFormatter.string(from: depDate!) : ""
                
                // MARK: Carrier code
                let carrierCodeString: String
                
                if let codeInt = seg.thread?.carrier?.code {
                    carrierCodeString = String(codeInt)
                } else if let iata = seg.thread?.carrier?.codes?.iata, !iata.isEmpty {
                    carrierCodeString = iata
                } else if let sirena = seg.thread?.carrier?.codes?.sirena, !sirena.isEmpty {
                    carrierCodeString = sirena
                } else if let icao = seg.thread?.carrier?.codes?.icao, !icao.isEmpty {
                    carrierCodeString = icao
                } else {
                    carrierCodeString = ""
                }
                
                // MARK: Duration
                let hours = (seg.duration ?? 0) / 3600
                
                return CarrierRouteModel(
                    carrierName: seg.thread?.carrier?.title ?? "Перевозчик",
                    carrierLogoURL: seg.thread?.carrier?.logo,
                    hasTransfer: seg.has_transfers ?? false,
                    departureTime: depTimeString,
                    arrivalTime: arrTimeString,
                    duration: "\(hours) ч.",
                    date: dateString,
                    carrierCode: carrierCodeString
                )
            }
            
        case .undocumented(let statusCode, _):
            throw NetworkError.httpError(statusCode: statusCode)
        }
    }
    
    // MARK: - Carrier information
    
    func getCarrierInfo(
        code: String,
        system: String? = nil
    ) async throws -> CarrierInfoResponse {
        
        // MARK: URL
        guard var components = URLComponents(string: "\(APIConstants.baseURL)/v3.0/carrier/") else {
            throw NetworkError.invalidResponse
        }
        
        // MARK: Query
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "lang", value: "ru_RU")
        ]
        
        if let system, !system.isEmpty {
            components.queryItems?.append(
                URLQueryItem(name: "system", value: system)
            )
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidResponse
        }
        
        // MARK: Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // MARK: Network
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // MARK: HTTP error
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // MARK: Decode
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(CarrierInfoResponse.self, from: data)
            return result
            
        } catch {
            throw error
        }
    }
}
