//
//  MainViewModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var departureCity: String = ""
    @Published var departureStation: String = ""
    @Published var destinationCity: String = ""
    @Published var destinationStation: String = ""
    
    @Published var searchText: String = ""
    
    @Published var showCityPicker = false
    @Published var isSelectingDeparture = true
    
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
        !departureCity.isEmpty && !destinationCity.isEmpty
    }
    
    // MARK: - Filter Logic
    var filteredCities: [City] {
        if searchText.isEmpty {
            return mockCities
        } else {
            return mockCities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func filteredStations(for cityName: String) -> [Station] {
        let cityStations = mockStations.filter { $0.cityName == cityName }
        if searchText.isEmpty {
            return cityStations
        } else {
            return cityStations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
    
    func selectCity(_ city: String, station: String = "") {
        if isSelectingDeparture {
            departureCity = city
            departureStation = station
        } else {
            destinationCity = city
            destinationStation = station
        }
        closeCityPicker()
    }
    
    func swapCities() {
        let tempCity = departureCity
        let tempStation = departureStation
        departureCity = destinationCity
        departureStation = destinationStation
        destinationCity = tempCity
        destinationStation = tempStation
    }
}
