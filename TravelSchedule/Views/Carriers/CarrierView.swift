import SwiftUI

struct CarrierView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CarrierViewModel
    
    init(viewModel: CarrierViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Logo URL
    
    private var imageURL: URL? {
        let logo = viewModel.logoURL
        guard !logo.isEmpty else { return nil }
        
        if logo.hasPrefix("http://") || logo.hasPrefix("https://") {
            return URL(string: logo)
        }
        
        if logo.hasPrefix("/") {
            return URL(string: "https://yastatic.net\(logo)")
        }
        
        return URL(string: logo)
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 16)
                
                // MARK: - Logo
                
                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 104)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(24)
                                .frame(height: 104)
                                .frame(maxWidth: .infinity)
                        case .failure:
                            placeholderLogo
                        @unknown default:
                            placeholderLogo
                        }
                    }
                } else {
                    placeholderLogo
                }
                
                Spacer().frame(height: 16)
                
                // MARK: - Carrier name
                
                Text(viewModel.carrierName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                
                Spacer().frame(height: 24)
                
                // MARK: - Loading
                
                if viewModel.isLoading {
                    ProgressView("Загрузка информации...")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                } else {
                    // MARK: - Email
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("E-mail")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.primary)
                        
                        Text(viewModel.email.isEmpty ? "Информация отсутствует" : viewModel.email)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(viewModel.email.isEmpty ? .gray : .blue)
                    }
                    
                    Spacer().frame(height: 24)
                    
                    // MARK: - Phone
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Телефон")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundStyle(.primary)
                        
                        Text(viewModel.phone.isEmpty ? "Информация отсутствует" : viewModel.phone)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(viewModel.phone.isEmpty ? .gray : .blue)
                    }
                }
                
                // MARK: - Error
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundStyle(.red)
                        .padding(.top, 16)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Constants.Icons.back)
                        .font(Constants.Fonts.backButtonFont)
                        .foregroundStyle(.primary)
                }
            }
        }
        .task {
            await viewModel.fetchCarrierInfo()
        }
    }
    
    // MARK: - Placeholder
    
    private var placeholderLogo: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 104)
            .frame(maxWidth: .infinity)
            .overlay {
                Image(systemName: "building.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .foregroundStyle(.gray)
            }
    }
}
