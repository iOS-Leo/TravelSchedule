//
//  Travel_ScheduleApp.swift
//  Travel Schedule
//
//  Created by Leo Gabuev on 23.07.2026.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }
}
