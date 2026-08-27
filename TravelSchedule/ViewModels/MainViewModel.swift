//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var departureCity: String = ""
    @Published var departureStation: String = ""
    @Published var departureStationCode: String = ""
    
    @Published var destinationCity: String = ""
    @Published var destinationStation: String = ""
    @Published var destinationStationCode: String = ""
    
    @Published var searchText: String = ""
    
    @Published var showCityPicker = false
    @Published var isSelectingDeparture = true
    
    @Published var cities: [CityModel] = []
    @Published var routes: [CarrierRouteModel] = []
    @Published var isLoading = false
    @Published var isSearchingRoutes = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - Computed Properties
    var departureTitle: String {
        guard !departureCity.isEmpty else { return Constants.Strings.departurePlaceholder }
        return departureStation.isEmpty ? departureCity : "\(departureCity) (\(departureStation))"
    }
    
    var destinationTitle: String {
        guard !destinationCity.isEmpty else { return Constants.Strings.destinationPlaceholder }
        return destinationStation.isEmpty ? destinationCity : "\(destinationCity) (\(destinationStation))"
    }
    
    var canSearch: Bool {
        !departureStationCode.isEmpty && !destinationStationCode.isEmpty
    }
    
    // MARK: - Filter Logic
    var filteredCities: [CityModel] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func filteredStations(for city: CityModel) -> [StationModel] {
        if searchText.isEmpty {
            return city.stations
        } else {
            return city.stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // MARK: - Network API Calls
    func loadData() async {
        guard cities.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedCities = try await networkClient.getRussianCitiesAndStations()
            self.cities = fetchedCities
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
        }
    }
    
    func fetchRoutes(date: String? = nil, allowTransfers: Bool = true) async {
        guard canSearch else { return }
        
        isSearchingRoutes = true
        errorMessage = nil
        
        do {
            let fetchedRoutes = try await networkClient.searchSchedule(
                from: departureStationCode,
                to: destinationStationCode,
                date: date,
                transfers: allowTransfers
            )
            self.routes = fetchedRoutes
            self.isSearchingRoutes = false
        } catch {
            self.isSearchingRoutes = false
            self.errorMessage = "Ошибка поиска: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Actions
    func openCityPicker(forDeparture: Bool) {
        searchText = ""
        isSelectingDeparture = forDeparture
        showCityPicker = true
    }
    
    func closeCityPicker() {
        showCityPicker = false
        searchText = ""
    }
    
    func selectStation(city: CityModel, station: StationModel) {
        if isSelectingDeparture {
            departureCity = city.name
            departureStation = station.name
            departureStationCode = station.id
        } else {
            destinationCity = city.name
            destinationStation = station.name
            destinationStationCode = station.id
        }
        closeCityPicker()
    }
    
    func swapCities() {
        let tempCity = departureCity
        let tempStation = departureStation
        let tempCode = departureStationCode
        
        departureCity = destinationCity
        departureStation = destinationStation
        departureStationCode = destinationStationCode
        
        destinationCity = tempCity
        destinationStation = tempStation
        destinationStationCode = tempCode
    }
}
