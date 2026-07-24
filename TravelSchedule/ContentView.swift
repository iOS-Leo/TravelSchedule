//
//  ContentView.swift
//  Travel Schedule
//
//  Created by Leo Gabuev on 23.07.2026.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testAllServices()
        }
    }
}

#Preview {
    ContentView()
}

func testAllServices() {
    Task {
        let apiKey = "da376864-7e73-417e-946b-aee48bb51b36"
        let baseURL = (try? Servers.Server1.url()) ?? URL(string: "https://api.rasp.yandex.net")!

        let client = Client(
            serverURL: baseURL,
            transport: URLSessionTransport()
        )
        
        do {
            let service = NearestStationsService(client: client, apikey: apiKey)
            let stations = try await service.getNearestStations(lat: 55.7520, lng: 37.6175, distance: 10)
            print("Успех! Найдено станций: \(stations.stations?.count ?? 0)")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        do {
            let service = SearchScheduleService(client: client, apikey: apiKey)
            _ = try await service.searchSchedule(from: "c146", to: "c213", date: "2026-08-01")
            print("Успех")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        do {
            let service = StationScheduleService(client: client, apikey: apiKey)
            _ = try await service.getStationSchedule(station: "s9600213", date: "2026-08-01")
            print("Успех")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        do {
            let service = RouteStationsService(client: client, apikey: apiKey)
            _ = try await service.getRouteStations(uid: "038AA_tis")
            print("Успех")
        } catch {
            print("Ошибка устаревшего UID): \(error.localizedDescription)")
        }
        
        do {
            let service = NearestCityService(client: client, apikey: apiKey)
            _ = try await service.getNearestCity(lat: 55.7520, lng: 37.6175)
            print("Успех")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        do {
            let service = CarrierInfoService(client: client, apikey: apiKey)
            _ = try await service.getCarrierInfo(code: "112")
            print("Успех")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        do {
            let service = AllStationsService(client: client, apikey: apiKey)
            _ = try await service.getAllStations()
            print("Успех")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        do {
            let service = CopyrightService(client: client, apikey: apiKey)
            _ = try await service.getCopyright(format: "json")
            print("Успех")
        } catch {
            print("Ошибка: \(error.localizedDescription)")
        }
        
        print("\nТестирование всех 8 сервисов завершено!")
    }
}
