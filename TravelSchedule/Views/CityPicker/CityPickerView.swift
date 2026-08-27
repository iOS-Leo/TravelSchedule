//
//  CityPickerView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

struct CityPickerView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Фон экрана
                Constants.Colors.mainBackground
                    .ignoresSafeArea()
                
                // MARK: - Основной контент
                VStack(spacing: 0) {
                    // MARK: - Поисковая строка
                    SearchBarView(text: $viewModel.searchText)
                    
                    // MARK: - Состояния загрузки / Список городов / Пустое состояние
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView("Загрузка станций...")
                            Spacer()
                        }
                    } else if viewModel.filteredCities.isEmpty {
                        VStack {
                            Text(Constants.Strings.cityNotFound)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.top, 176)
                    } else {
                        List(viewModel.filteredCities) { city in
                            ZStack {
                                NavigationLink {
                                    StationPickerView(
                                        city: city,
                                        viewModel: viewModel
                                    )
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                HStack {
                                    Text(city.name)
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: Constants.Icons.forward)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                .frame(height: Constants.Layout.listRowHeight)
                                .contentShape(Rectangle())
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: Constants.Layout.horizontalPadding, bottom: 0, trailing: Constants.Layout.horizontalPadding))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle(Constants.Strings.cityPickerTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.closeCityPicker()
                    } label: {
                        Image(systemName: Constants.Icons.back)
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 24, height: 24)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    CityPickerView(viewModel: MainViewModel())
}
