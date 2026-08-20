//
//  ErrorView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

import SwiftUI

struct ErrorView: View {
    let errorType: ErrorType
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(errorType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .clipShape(RoundedRectangle(cornerRadius: 38, style: .continuous))
            
            Text(errorType.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview("Нет интернета") {
    ErrorView(errorType: .noInternet)
}

#Preview("Ошибка сервера") {
    ErrorView(errorType: .serverError)
}
