//
//  SearchBarView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: Constants.Icons.search)
                .foregroundColor(.secondary)
            
            TextField(Constants.Strings.searchPlaceholder, text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: Constants.Icons.clearText)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: Constants.Layout.searchBarHeight)
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
        .padding(.horizontal, Constants.Layout.horizontalPadding)
        .padding(.top, 8)
        .padding(.bottom, Constants.Layout.searchToListPadding)
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
