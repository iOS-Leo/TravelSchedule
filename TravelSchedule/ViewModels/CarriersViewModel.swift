import Foundation
import SwiftUI
import Combine

final class CarriersViewModel: ObservableObject {
    let departure: String
    let destination: String
    
    @Published var appliedFilters = FilterState()
    
    @Published var carriers: [Carrier] = mockCarriers
    
    init(departure: String, destination: String) {
        self.departure = departure
        self.destination = destination
    }
    
    var filteredCarriers: [Carrier] {
        guard appliedFilters.isAnyFilterSelected else {
            return carriers
        }
        return carriers
    }
}
