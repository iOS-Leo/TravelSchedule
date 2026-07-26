//
//  StationScheduleService.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 24.07.2026.
//

import OpenAPIRuntime
import OpenAPIURLSession

typealias StationScheduleResponse = Components.Schemas.ScheduleResponse

protocol StationScheduleServiceProtocol {
    func getStationSchedule(
        station: String,
        date: String?,
        transportTypes: String?,
        event: String?,
        direction: String?,
        system: String?,
        resultTimezone: String?
    ) async throws -> StationScheduleResponse
}

final class StationScheduleService: StationScheduleServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(
        station: String,
        date: String? = nil,
        transportTypes: String? = nil,
        event: String? = nil,
        direction: String? = nil,
        system: String? = nil,
        resultTimezone: String? = nil
    ) async throws -> StationScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(
            apikey: apikey,
            station: station,
            date: date,
            transport_types: transportTypes,
            event: event,
            direction: direction,
            system: system,
            result_timezone: resultTimezone
        ))
        
        return try response.ok.body.json
    }
}
