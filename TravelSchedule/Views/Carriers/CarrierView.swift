//
//  CarrierView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 21.08.2026.
//

import SwiftUI

struct CarrierView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    let carrierName: String
    let logoImageName: String
    let email: String
    let phone: String
    
    private var imageURL: URL? {
        guard !logoImageName.isEmpty else { return nil }
        
        if logoImageName.hasPrefix("http://") || logoImageName.hasPrefix("https://") {
            return URL(string: logoImageName)
        }
        if logoImageName.hasPrefix("/") {
            return URL(string: "https://yastatic.net\(logoImageName)")
        }
        
        return URL(string: logoImageName)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 16)
                
                // MARK: - Асинхронная загрузка логотипа
                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 104)
                                .frame(maxWidth: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(24)
                                .frame(height: 104)
                                .frame(maxWidth: .infinity)
                        case .failure(let error):
                            let _ = print("❌ [CarrierView] Ошибка загрузки картинки: \(error)")
                            placeholderLogo
                        @unknown default:
                            placeholderLogo
                        }
                    }
                } else if !logoImageName.isEmpty, UIImage(named: logoImageName) != nil {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(24)
                        .frame(height: 104)
                        .frame(maxWidth: .infinity)
                } else {
                    placeholderLogo
                }
                
                Spacer().frame(height: 16)
                
                Text(carrierName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                
                Spacer().frame(height: 24)
                
                VStack(alignment: .leading, spacing: 24) {
                    ContactInfoRow(title: "E-mail", value: email.isEmpty ? "Не указан" : email)
                    ContactInfoRow(title: "Телефон", value: phone.isEmpty ? "Не указан" : phone)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Constants.Icons.back)
                        .font(Constants.Fonts.backButtonFont)
                        .foregroundColor(.primary)
                }
            }
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
    
    private var placeholderLogo: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 104)
            .frame(maxWidth: .infinity)
            .overlay(
                Image(systemName: "building.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .foregroundColor(.gray)
            )
    }
}

private struct ContactInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.primary)
            
            Text(value)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.blue)
        }
    }
}
