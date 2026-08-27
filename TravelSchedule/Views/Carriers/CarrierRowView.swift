//
//  CarrierRowView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.08.2026.
//

import SwiftUI

struct CarrierRowView: View {
    let route: CarrierRouteModel
    
    var body: some View {
        VStack(spacing: 14) {
            HStack(alignment: .top, spacing: 8) {
                if let logoURLString = route.carrierLogoURL, let url = URL(string: logoURLString) {
                    AsyncImage(url: url) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 38, height: 38)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "train.side.front.car")
                        .resizable()
                        .scaledToFit()
                        .padding(8)
                        .frame(width: 38, height: 38)
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(route.carrierName)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.black)
                    
                    if route.hasTransfer {
                        Text("С пересадкой")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(Color(red: 0.98, green: 0.4, blue: 0.4))
                    }
                }
                
                Spacer()
                Text(formattedDate(route.date))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.black)
            }
            
            HStack(alignment: .center, spacing: 4) {
                Text(route.departureTime)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text(route.duration)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.black)
                    .layoutPriority(1)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                Text(route.arrivalTime)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .padding(14)
        .background(Color(red: 0.95, green: 0.95, blue: 0.96))
        .cornerRadius(24)
    }
    
    private func formattedDate(_ dateString: String) -> String {
        guard !dateString.isEmpty else {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM"
            outputFormatter.locale = Locale(identifier: "ru_RU")
            return outputFormatter.string(from: Date())
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "ru_RU")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM"
            outputFormatter.locale = Locale(identifier: "ru_RU")
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
}
