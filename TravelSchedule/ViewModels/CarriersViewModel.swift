import Foundation
import SwiftUI
import Combine

final class CarriersViewModel: ObservableObject {
    let departure: String
    let destination: String
    
    @Published var appliedFilters = FilterState()
    
    @Published var carriers: [CarrierItem] = [
        CarrierItem(imageResource: .rzd),
        CarrierItem(imageResource: .fgk),
        CarrierItem(imageResource: .ural),
        CarrierItem(imageResource: .rzd2)
    ]
    
    init(departure: String, destination: String) {
        self.departure = departure
        self.destination = destination
    }
    
    var filteredCarriers: [CarrierItem] {
        guard appliedFilters.isAnyFilterSelected else {
            return carriers
        }
        return carriers
    }
}
