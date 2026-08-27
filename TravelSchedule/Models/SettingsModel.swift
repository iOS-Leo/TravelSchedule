//
//  SettingsModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 24.08.2026.
//

import Foundation

struct SettingsModel {
    private let userDefaults: UserDefaults
    private let themeKey = "isDarkModeEnabled"
    
    let agreementURL: URL? = URL(string: "https://yandex.ru/legal/practicum_offer")
    let appVersion: String = "1.0"
    let apiCredit: String = "Приложение использует API Яндекс.Расписания."
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isDarkModeEnabled: Bool {
        get {
            userDefaults.bool(forKey: themeKey)
        }
        set {
            userDefaults.set(newValue, forKey: themeKey)
        }
    }
}
