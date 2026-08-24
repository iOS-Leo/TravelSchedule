//
//  SettingsView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    Toggle("Темная тема", isOn: $viewModel.isDarkModeEnabled)
                        .frame(height: 60)
                        .tint(.blue)
                        .listRowSeparator(.hidden)
                        .font(Constants.Fonts.bodyRegular)
                        .listRowBackground(Color.clear)
                    
                    Button {
                        viewModel.openAgreement()
                    } label: {
                        HStack {
                            Text("Пользовательское соглашение")
                                .font(Constants.Fonts.bodyRegular)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: Constants.Icons.forward)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
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
                    Text(viewModel.apiCredit)
                        .font(.system(size: 12))
                        .tracking(0.4)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Версия \(viewModel.appVersion)")
                        .font(.system(size: 12))
                        .tracking(0.4)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Constants.Colors.mainBackground.ignoresSafeArea())
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $viewModel.showAgreement) {
                if let url = viewModel.agreementURL {
                    AgreementWebViewContainer(
                        viewModel: viewModel,
                        url: url
                    )
                }
            }
            .preferredColorScheme(viewModel.isDarkModeEnabled ? .dark : .light)
        }
    }
}
