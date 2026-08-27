import Foundation
import Combine

@MainActor
final class CarrierViewModel: ObservableObject {
    
    // MARK: - Данные перевозчика
    
    let carrierCode: String
    
    @Published var carrierName: String
    @Published var logoURL: String
    
    @Published var email: String = ""
    @Published var phone: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Network
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(
        carrierCode: String,
        carrierNameFallback: String = "",
        logoURLFallback: String = "",
        networkClient: NetworkClient = NetworkClient()
    ) {
        self.carrierCode = carrierCode
        self.carrierName = carrierNameFallback
        self.logoURL = logoURLFallback
        self.networkClient = networkClient
    }
    
    // MARK: - Fetch carrier info
    
    func fetchCarrierInfo() async {
        
        guard !carrierCode.isEmpty else {
            errorMessage = "Код перевозчика отсутствует"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        email = ""
        phone = ""
        
        do {
            let response = try await networkClient.getCarrierInfo(
                code: carrierCode,
                system: "yandex"
            )
            guard let carrier = response.carrier ?? response.carriers?.first else {
                errorMessage = "Информация о перевозчике не найдена"
                isLoading = false
                return
            }
            
            // MARK: - Название
            
            if let title = carrier.title, !title.isEmpty {
                carrierName = title
            }
            
            // MARK: - Логотип
            
            if let logo = carrier.logo, !logo.isEmpty {
                logoURL = logo
            }
            
            // MARK: - Email
            
            if let carrierEmail = carrier.email, !carrierEmail.isEmpty {
                email = carrierEmail
            }
            
            // MARK: - Телефон
            
            if let carrierPhone = carrier.phone, !carrierPhone.isEmpty {
                phone = carrierPhone
            }
            
            // MARK: - Contacts
            
            if let contacts = carrier.contacts, !contacts.isEmpty {
                
                if email.isEmpty {
                    let emailPattern = #" [A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,} "#
                    
                    if let regex = try? NSRegularExpression(
                        pattern: emailPattern,
                        options: [.caseInsensitive]
                    ) {
                        let range = NSRange(
                            location: 0,
                            length: contacts.utf16.count
                        )
                        
                        if let match = regex.firstMatch(
                            in: contacts,
                            options: [],
                            range: range
                        ) {
                            email = (contacts as NSString).substring(with: match.range)
                        }
                    }
                }
                
                if phone.isEmpty {
                    let phonePattern = #"(?:\+?\d[\d\s\-\(\)]{6,}\d)"#
                    
                    if let regex = try? NSRegularExpression(pattern: phonePattern) {
                        let range = NSRange(
                            location: 0,
                            length: contacts.utf16.count
                        )
                        
                        if let match = regex.firstMatch(
                            in: contacts,
                            options: [],
                            range: range
                        ) {
                            phone = (contacts as NSString).substring(with: match.range)
                        }
                    }
                }
            }
            
            isLoading = false
            
        } catch {
            errorMessage = "Ошибка загрузки информации"
            isLoading = false
        }
    }
}
