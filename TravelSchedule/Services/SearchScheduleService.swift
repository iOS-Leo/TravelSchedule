//
//  SearchScheduleService.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 24.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol SearchScheduleServiceProtocol {
    func searchSchedule(
        from: String,
        to: String,
        date: String?,
        transportTypes: String?,
        offset: Int?,
        limit: Int?,
        transfers: Bool?
    ) async throws -> Segments
}

final class SearchScheduleService: SearchScheduleServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func searchSchedule(
        from: String,
        to: String,
        date: String? = nil,
        transportTypes: String? = nil,
        offset: Int? = nil,
        limit: Int? = nil,
        transfers: Bool? = nil
    ) async throws -> Segments {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            date: date,
            transport_types: transportTypes,
            offset: offset,
            limit: limit,
            transfers: transfers
        ))
        
        return try response.ok.body.json
    }
}
