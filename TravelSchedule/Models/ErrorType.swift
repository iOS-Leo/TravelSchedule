//
//  ErrorType.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import Foundation

enum ErrorType {
    case noInternet
    case serverError
    
    var title: String {
        switch self {
        case .noInternet:
            return Constants.ErrorStrings.noInternet
        case .serverError:
            return Constants.ErrorStrings.serverError
        }
    }
    
    var imageName: String {
        switch self {
        case .noInternet:
            return Constants.ImageAssets.noInternet
        case .serverError:
            return Constants.ImageAssets.serverError
        }
    }
}
