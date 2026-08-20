//
//  Models.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import Foundation
import SwiftUI

// MARK: - Carrier Model
struct CarrierItem: Identifiable {
    let id = UUID()
    let imageResource: ImageResource
}

// MARK: - Filter Models
enum DepartureTime: CaseIterable, Identifiable {
    case morning
    case afternoon
    case evening
    case night
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .morning:
            return Constants.FilterStrings.morning
        case .afternoon:
            return Constants.FilterStrings.afternoon
        case .evening:
            return Constants.FilterStrings.evening
        case .night:
            return Constants.FilterStrings.night
        }
    }
}

enum TransferOption: CaseIterable, Identifiable {
    case yes
    case no
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .yes:
            return Constants.FilterStrings.transferYes
        case .no:
            return Constants.FilterStrings.transferNo
        }
    }
}

struct FilterState {
    var selectedTimes: Set<DepartureTime> = []
    var selectedTransfer: TransferOption? = nil
    
    var isAnyFilterSelected: Bool {
        !selectedTimes.isEmpty || selectedTransfer != nil
    }
}
