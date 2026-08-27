//
//  CarriersListView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

struct CarriersListView: View {
    
    @StateObject private var viewModel: CarriersViewModel
    @State private var showFilters = false
    @Environment(\.dismiss) private var dismiss

    init(viewModel: CarriersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Constants.Colors.mainBackground
                .ignoresSafeArea()
              
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(viewModel.departureTitle) → \(viewModel.destinationTitle)")
                        .font(.system(size: Constants.Layout.mainTitleFontSize, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                        .padding(.vertical, Constants.Layout.horizontalPadding)
                    
                    // MARK: - Состояния экрана
                    if viewModel.isLoading {
                        VStack {
                            Spacer().frame(height: 60)
                            ProgressView("Загрузка расписания...")
                                .frame(maxWidth: .infinity)
                        }
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 12) {
                            Spacer().frame(height: 40)
                            Text(error)
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Попробовать снова") {
                                Task {
                                    await viewModel.fetchRoutes()
                                }
                            }
                            .font(.subheadline.bold())
                        }
                    } else if viewModel.filteredRoutes.isEmpty {
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
                            ForEach(viewModel.filteredRoutes) { route in
                                NavigationLink(destination: CarrierView(
                                    carrierName: route.carrierName,
                                    logoImageName: route.carrierLogoURL ?? "",
                                    email: "",
                                    phone: ""
                                )) {
                                    CarrierRowView(route: route)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                        .padding(.bottom, Constants.Layout.listBottomPadding)
                    }
                }
            }
            .task {
                await viewModel.fetchRoutes()
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
