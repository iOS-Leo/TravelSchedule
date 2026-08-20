//
//  FilterViewModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import Foundation
import SwiftUI
import Combine

final class FilterViewModel: ObservableObject {
    @Published var state: FilterState
    
    init(initialState: FilterState = FilterState()) {
        self.state = initialState
    }
    
    func toggleTime(_ time: DepartureTime) {
        if state.selectedTimes.contains(time) {
            state.selectedTimes.remove(time)
        } else {
            state.selectedTimes.insert(time)
        }
    }
    
    func selectTransfer(_ option: TransferOption) {
        state.selectedTransfer = option
    }
}
