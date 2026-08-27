//
//  String+Contacts.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.08.2026.
//

import Foundation

import Foundation

extension String {
    var phoneURL: URL? {
        let cleanPhone = self.components(
            separatedBy: CharacterSet.decimalDigits.inverted
                .union(CharacterSet(charactersIn: "+")).inverted
        ).joined()
        return URL(string: "tel://\(cleanPhone)")
    }
    
    var emailURL: URL? {
        guard let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "mailto:\(encoded)")
    }
}
