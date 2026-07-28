//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.mainBackground
                    .ignoresSafeArea()
                ErrorView(errorType: .serverError)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
}
