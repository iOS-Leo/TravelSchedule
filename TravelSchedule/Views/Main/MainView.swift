//
//  MainView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Фон экрана
                Constants.Colors.mainBackground
                    .ignoresSafeArea()
                
                // MARK: - Основной контент
                VStack(spacing: 0) {
                    // MARK: - Синий контейнер выбора городов
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 0) {
                            Button {
                                viewModel.openCityPicker(forDeparture: true)
                            } label: {
                                Text(viewModel.departureTitle)
                                    .font(.system(size: 17))
                                    .foregroundColor(viewModel.departureCity.isEmpty ? .gray : .black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 48)
                            }
                            
                            Button {
                                viewModel.openCityPicker(forDeparture: false)
                            } label: {
                                Text(viewModel.destinationTitle)
                                    .font(.system(size: 17))
                                    .foregroundColor(viewModel.destinationCity.isEmpty ? .gray : .black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .frame(height: 48)
                            }
                        }
                        .padding(.horizontal, Constants.Layout.horizontalPadding)
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        Button {
                            viewModel.swapCities()
                        } label: {
                            Image(systemName: Constants.Icons.swap)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(Constants.Layout.horizontalPadding)
                    .background(Color.blue)
                    .cornerRadius(24)
                    .padding(.horizontal, Constants.Layout.horizontalPadding)
                    .padding(.top, 208)
                    
                    // MARK: - Кнопка "Найти"
                    if viewModel.canSearch {
                        NavigationLink {
                            CarriersListView(
                                viewModel: CarriersViewModel(
                                    departure: viewModel.departureTitle,
                                    destination: viewModel.destinationTitle
                                )
                            )
                        } label: {
                            Text(Constants.Strings.findButtonTitle)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 150, height: 60)
                                .background(Color.blue)
                                .cornerRadius(16)
                        }
                        .padding(.top, Constants.Layout.horizontalPadding)
                    }
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $viewModel.showCityPicker) {
                CityPickerView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MainView()
}
