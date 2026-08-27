//
//  FlexibleDateTranscoder.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.08.2026.
//

import Foundation
import OpenAPIRuntime

struct FlexibleDateTranscoder: DateTranscoder {
    private let iso8601WithFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private let iso8601Standard: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private let iso8601Simple: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private let timeOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    func encode(_ date: Date) throws -> String {
        return iso8601Standard.string(from: date)
    }

    func decode(_ dateString: String) throws -> Date {
        if let date = iso8601WithFractionalSeconds.date(from: dateString) {
            return date
        }
        
        if let date = iso8601Standard.date(from: dateString) {
            return date
        }
        
        if let date = iso8601Simple.date(from: dateString) {
            return date
        }
        
        if let date = timeOnlyFormatter.date(from: dateString) {
            return date
        }
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: [],
                debugDescription: "Не удалось распарсить дату: \(dateString)"
            )
        )
    }
}
