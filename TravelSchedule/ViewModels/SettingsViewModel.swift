//
//  SettingsViewModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 24.08.2026.
//

import Foundation

@Observable
final class SettingsViewModel {
    private var model: SettingsModel
    
    var showAgreement: Bool = false
    var isWebViewLoading: Bool = true
    
    init(model: SettingsModel = SettingsModel()) {
        self.model = model
    }
    
    // Перенаправляем свойства из модели
    var isDarkModeEnabled: Bool {
        get { model.isDarkModeEnabled }
        set { model.isDarkModeEnabled = newValue }
    }
    
    var agreementURL: URL? { model.agreementURL }
    var appVersion: String { model.appVersion }
    var apiCredit: String { model.apiCredit }
    
    func openAgreement() {
        isWebViewLoading = true
        showAgreement = true
    }
    
    func webViewDidFinishLoading() {
        isWebViewLoading = false
    }
}
