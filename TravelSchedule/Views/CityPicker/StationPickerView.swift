//
//  StationPickerView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import SwiftUI

struct StationPickerView: View {
    let cityName: String
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // MARK: - Фон экрана
            Constants.Colors.mainBackground
                .ignoresSafeArea()
            
            // MARK: - Основной контент
            VStack(spacing: 0) {
                // MARK: - Поисковая строка
                SearchBarView(text: $viewModel.searchText)
                
                // MARK: - Список станций / Пустое состояние
                let stations = viewModel.filteredStations(for: cityName)
                
                if stations.isEmpty {
                    VStack {
                        Text(Constants.Strings.stationNotFound)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.top, 176)
                } else {
                    List {
                        ForEach(stations, id: \.id) { station in
                            Button {
                                viewModel.selectCity(cityName, station: station.name)
                            } label: {
                                HStack {
                                    Text(station.name)
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
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle(Constants.Strings.stationPickerTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
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
