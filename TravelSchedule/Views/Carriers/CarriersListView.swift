//
//  CarriersListView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

struct CarriersListView: View {
    
    @ObservedObject var viewModel: CarriersViewModel
    
    @State private var showFilters = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(viewModel.departure) → \(viewModel.destination)")
                        .font(.system(size: Constants.Layout.mainTitleFontSize, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                        .padding(.vertical, Constants.Layout.horizontalPadding)
                    
                    if viewModel.filteredCarriers.isEmpty {
                        VStack {
                            Spacer().frame(height: Constants.Layout.emptyStateSpacerHeight)
                            Text(Constants.Strings.noCarriersFound)
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    } else {
                        VStack(spacing: 8) {
                            ForEach(viewModel.filteredCarriers) { item in
                                Image(item.imageResource)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                        .padding(.bottom, Constants.Layout.listBottomPadding)
                    }
                }
            }
            
            Button {
                showFilters = true
            } label: {
                Text(Constants.Strings.filterButtonTitle)
                    .font(Constants.Fonts.bodyRegular.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.Layout.mainButtonHeight)
                    .background(Color.blue)
                    .cornerRadius(Constants.Layout.mainButtonCornerRadius)
            }
            .padding(.horizontal, Constants.Layout.horizontalPadding)
            .padding(.bottom, Constants.Layout.horizontalPadding)
        }
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
        .fullScreenCover(isPresented: $showFilters) {
            FilterView(initialFilters: viewModel.appliedFilters) { updatedFilters in
                viewModel.appliedFilters = updatedFilters
            }
        }
    }
}

#Preview {
    NavigationStack {
        CarriersListView(
            viewModel: CarriersViewModel(
                departure: "Москва (Ярославский вокзал)",
                destination: "Санкт-Петербург (Балтийский вокзал)"
            )
        )
    }
}
