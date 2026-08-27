//
//  NetworkClient.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.08.2026.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

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

enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}

// MARK: - NetworkClient

actor NetworkClient {
    private let client: Client
    private let apiKey: String
    private let jsonDecoder = JSONDecoder()
    
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
    
    func getRussianCitiesAndStations() async throws -> [CityModel] {
        let response = try await client.getAllStations(query: .init(
            apikey: apiKey,
            lang: "ru_RU",
            format: "json"
        ))
        
        switch response {
        case .ok(let okResponse):
            let limit = 50 * 1024 * 1024
            let htmlBody = try await okResponse.body.html
            let fullData = try await Data(collecting: htmlBody, upTo: limit)
            let allStations = try jsonDecoder.decode(Components.Schemas.AllStationsResponse.self, from: fullData)
            
            guard let countries = allStations.countries else { return [] }
            let russia = countries.first { country in
                country.title?.lowercased().contains("россия") == true
            }
            
            guard let regions = russia?.regions else { return [] }
            
            var resultCities: [CityModel] = []
            
            for region in regions {
                guard let settlements = region.settlements else { continue }
                for settlement in settlements {
                    guard let cityName = settlement.title,
                          let cityCode = settlement.codes?.yandex_code,
                          !cityName.isEmpty else { continue }
                    
                    let parsedStations: [StationModel] = (settlement.stations ?? []).compactMap { station in
                        guard let stationName = station.title,
                              let stationCode = station.codes?.yandex_code ?? station.code,
                              !stationCode.isEmpty else { return nil }
                        return StationModel(id: stationCode, name: stationName, cityName: cityName)
                    }
                    
                    if !parsedStations.isEmpty {
                        resultCities.append(CityModel(id: cityCode, name: cityName, stations: parsedStations))
                    }
                }
            }
            
            return resultCities.sorted { $0.name < $1.name }
            
        case .undocumented(let statusCode, _):
            throw NetworkError.httpError(statusCode: statusCode)
        }
    }
    
    func searchSchedule(
        from: String,
        to: String,
        date: String? = nil,
        transfers: Bool = true
    ) async throws -> [CarrierRouteModel] {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apiKey,
            from: from,
            to: to,
            format: "json",
            lang: "ru_RU",
            date: date,
            transfers: transfers
        ))
        
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
                
                let carrierCodeString: String
                if let codeInt = seg.thread?.carrier?.code {
                    carrierCodeString = String(codeInt)
                } else {
                    carrierCodeString = ""
                }
                
                return CarrierRouteModel(
                    carrierName: seg.thread?.carrier?.title ?? "Перевозчик",
                    carrierLogoURL: seg.thread?.carrier?.logo,
                    hasTransfer: seg.has_transfers ?? false,
                    departureTime: depTimeString,
                    arrivalTime: arrTimeString,
                    duration: "\( (seg.duration ?? 0) / 3600 ) ч.",
                    date: dateString,
                    carrierCode: carrierCodeString
                )
            }
            
        case .undocumented(let statusCode, _):
            throw NetworkError.httpError(statusCode: statusCode)
        }
    }
    
    func getCarrierInfo(code: String) async throws -> Components.Schemas.CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(
            apikey: apiKey,
            code: code
        ))
        
        switch response {
        case .ok(let okResponse):
            return try await okResponse.body.json
        case .undocumented(let statusCode, _):
            throw NetworkError.httpError(statusCode: statusCode)
        }
    }
}
