//
//  FilterView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: FilterViewModel
    var onApply: (FilterState) -> Void
    
    init(initialFilters: FilterState = FilterState(), onApply: @escaping (FilterState) -> Void = { _ in }) {
        _viewModel = StateObject(wrappedValue: FilterViewModel(initialState: initialFilters))
        self.onApply = onApply
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(Constants.Strings.departureTimeSectionTitle)
                                .font(.system(size: 24, weight: .bold))
                            
                            VStack(spacing: 0) {
                                ForEach(DepartureTime.allCases) { time in
                                    Button {
                                        viewModel.toggleTime(time)
                                    } label: {
                                        HStack {
                                            Text(time.title)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: viewModel.state.selectedTimes.contains(time) ? Constants.Icons.checkboxSelected : Constants.Icons.checkboxUnselected)
                                                .font(.system(size: 22))
                                                .foregroundColor(viewModel.state.selectedTimes.contains(time) ? .black : Color(uiColor: .systemGray3))
                                        }
                                        .frame(height: Constants.Layout.listRowHeight)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(Constants.Strings.transferSectionTitle)
                                .font(.system(size: 24, weight: .bold))
                            
                            VStack(spacing: 0) {
                                ForEach(TransferOption.allCases) { option in
                                    Button {
                                        viewModel.selectTransfer(option)
                                    } label: {
                                        HStack {
                                            Text(option.title)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Image(systemName: viewModel.state.selectedTransfer == option ? Constants.Icons.radioButtonSelected : Constants.Icons.radioButtonUnselected)
                                                .font(.system(size: 22))
                                                .foregroundColor(viewModel.state.selectedTransfer == option ? .black : Color(uiColor: .systemGray3))
                                        }
                                        .frame(height: Constants.Layout.listRowHeight)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Constants.Layout.horizontalPadding)
                    .padding(.top, Constants.Layout.horizontalPadding)
                    .padding(.bottom, 100)
                }
                
                if viewModel.state.isAnyFilterSelected {
                    Button {
                        onApply(viewModel.state)
                        dismiss()
                    } label: {
                        Text(Constants.Strings.applyButtonTitle)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, Constants.Layout.horizontalPadding)
                    .padding(.bottom, Constants.Layout.horizontalPadding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.state.isAnyFilterSelected)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: Constants.Icons.back)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
