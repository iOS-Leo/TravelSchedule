import Foundation
import SwiftUI
import Combine

@MainActor
final class CarriersViewModel: ObservableObject {
    let departureTitle: String
    let destinationTitle: String
    let departureCode: String
    let destinationCode: String
    
    @Published var appliedFilters = FilterState()
    @Published var routes: [CarrierRouteModel] = []
    @Published var isLoading = true
    @Published var errorMessage: String? = nil
    
    private let networkClient: NetworkClient
    
    init(
        departureTitle: String,
        destinationTitle: String,
        departureCode: String,
        destinationCode: String,
        networkClient: NetworkClient = NetworkClient()
    ) {
        self.departureTitle = departureTitle
        self.destinationTitle = destinationTitle
        self.departureCode = departureCode
        self.destinationCode = destinationCode
        self.networkClient = networkClient
    }
    
    // MARK: - Network API Call
    func fetchRoutes() async {
        if routes.isEmpty {
            isLoading = true
        }
        errorMessage = nil
        
        print("🔍 [CarriersViewModel] Старт загрузки рейсов:")
        print("   • Departure: \(departureTitle) (code: '\(departureCode)')")
        print("   • Destination: \(destinationTitle) (code: '\(destinationCode)')")
        
        do {
            let fetchedRoutes = try await networkClient.searchSchedule(
                from: departureCode,
                to: destinationCode,
                date: nil,
                transfers: true
            )
            
            print("[CarriersViewModel] Сервер вернул рейсов: \(fetchedRoutes.count)")
            self.routes = fetchedRoutes
            self.isLoading = false
        } catch {
            print("[CarriersViewModel] Ошибка сетевого запроса: \(error)")
            self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
            self.routes = []
            self.isLoading = false
        }
    }
    
    // MARK: - Filter Logic
    var filteredRoutes: [CarrierRouteModel] {
        guard appliedFilters.isAnyFilterSelected else {
            return routes
        }
        
        return routes.filter { route in
            if let transferOption = appliedFilters.selectedTransfer {
                switch transferOption {
                case .yes:
                    if !route.hasTransfer { return false }
                case .no:
                    if route.hasTransfer { return false }
                }
            }
            
            if !appliedFilters.selectedTimes.isEmpty {
                let departureHour = extractHour(from: route.departureTime)
                let matchesTime = appliedFilters.selectedTimes.contains { timeOption in
                    switch timeOption {
                    case .morning:   return (6...11).contains(departureHour)
                    case .afternoon: return (12...17).contains(departureHour)
                    case .evening:   return (18...23).contains(departureHour)
                    case .night:     return (0...5).contains(departureHour)
                    }
                }
                if !matchesTime { return false }
            }
            
            return true
        }
    }
    
    private func extractHour(from timeString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: timeString) {
            return Calendar.current.component(.hour, from: date)
        }
        let components = timeString.split(separator: ":")
        if let first = components.first, let hour = Int(first) {
            return hour
        }
        return 0
    }
}
