//
//  AllStationsService.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 24.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol AllStationsServiceProtocol {
    func getAllStations(lang: String?, format: String?) async throws -> AllStationsResponse
}

final class AllStationsService: AllStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations(lang: String? = nil, format: String? = nil) async throws -> AllStationsResponse {
        let response = try await client.getAllStations(query: .init(
            apikey: apikey,
            lang: lang,
            format: format
        ))
        let limit = 50 * 1024 * 1024
        let fullData = try await Data(collecting: try response.ok.body.html, upTo: limit)
        let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
        
        return allStations
    }
}
