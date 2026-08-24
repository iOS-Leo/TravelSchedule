//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    @State private var showAgreement = false
    
    private let agreementURL = URL(string: "https://yandex.ru/legal/practicum_offer")!
    
    var body: some View {
        NavigationStack {
            ZStack {
                Constants.Colors.mainBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    List {
                        Toggle("Темная тема", isOn: $isDarkModeEnabled)
                            .frame(height: 60)
                            .tint(.blue)
                            .listRowSeparator(.hidden)
                            .font(Constants.Fonts.bodyRegular)
                            .listRowBackground(Color.clear)
                        
                        Button {
                            showAgreement = true
                        } label: {
                            HStack {
                                Text("Пользовательское соглашение")
                                    .font(Constants.Fonts.bodyRegular)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: Constants.Icons.forward)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(isDarkModeEnabled ? .white : .black)
                            }
                        }
                        .buttonStyle(.plain)
                        .frame(height: 60)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Text("Приложение использует API Яндекс.Расписания.")
                            .font(.system(size: 12))
                            .tracking(0.4)
                            .foregroundColor(.secondary)
                        
                        Text("Версия 1.0")
                            .font(.system(size: 12))
                            .tracking(0.4)
                            .foregroundColor(.secondary)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
                }
            }
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showAgreement) {
                AgreementWebViewContainer(isDarkMode: isDarkModeEnabled, url: agreementURL)
            }
        }
    }
}

struct AgreementWebViewContainer: View {
    let isDarkMode: Bool
    let url: URL
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                AgreementWebView(url: url, isDarkMode: isDarkMode)
                    .ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Соглашение")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .font(Constants.Fonts.bodyRegular.bold())
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
