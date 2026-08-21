//
//  CarrierView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 21.08.2026.
//

import SwiftUI

struct CarrierView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let carrierName: String
    let logoImageName: String
    let email: String
    let phone: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 16)
                    
                    Image(.logoRZD)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(24)
                        .frame(height: 104)
                        .frame(maxWidth: .infinity)
                    
                    Spacer().frame(height: 16)
                    
                    Text(carrierName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    Spacer().frame(height: 24)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        ContactInfoRow(title: "E-mail", value: email)
                        ContactInfoRow(title: "Телефон", value: phone)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Информация о перевозчике")
            .navigationBarTitleDisplayMode(.inline)
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
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

#Preview {
    CarrierView(
        carrierName: "ОАО «РЖД»",
        logoImageName: "logoRZD",
        email: "i.lozgkina@yandex.ru",
        phone: "+7 (904) 329-27-71"
    )
}
