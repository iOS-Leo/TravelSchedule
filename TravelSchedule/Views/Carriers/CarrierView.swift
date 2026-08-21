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
    let email: String
    let phone: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Spacer().frame(height: 24)
                    
                    Image(.logoRZD)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 104)
                        .frame(maxWidth: .infinity)
                    
                    Text(carrierName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
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
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.blue)
        }
    }
}

#Preview {
    CarrierView(
        carrierName: "ОАО «РЖД»",
        email: "info@rzd.ru",
        phone: "+7 (800) 775-00-00"
    )
}
