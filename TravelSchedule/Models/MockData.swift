//
//  MockData.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 27.07.2026.
//

import Foundation

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct Station: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let cityName: String
}

struct Carrier: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let logo: String
    let hasTransfer: Bool
    let transferCity: String?
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let date: String
    
    let email: String
    let phone: String
}

let mockCities = [
    City(name: "Москва"),
    City(name: "Санкт-Петербург"),
    City(name: "Сочи"),
    City(name: "Горный воздух"),
    City(name: "Краснодар"),
    City(name: "Казань"),
    City(name: "Омск")
]

let mockStations = [
    Station(name: "Киевский вокзал", cityName: "Москва"),
    Station(name: "Курский вокзал", cityName: "Москва"),
    Station(name: "Ярославский вокзал", cityName: "Москва"),
    Station(name: "Белорусский вокзал", cityName: "Москва"),
    Station(name: "Савеловский вокзал", cityName: "Москва"),
    Station(name: "Ленинградский вокзал", cityName: "Москва"),
    Station(name: "Балтийский вокзал", cityName: "Санкт-Петербург"),
    Station(name: "Московский вокзал", cityName: "Санкт-Петербург")
]

let mockCarriers = [
    Carrier(
        name: "РЖД",
        logo: "rzd",
        hasTransfer: true,
        transferCity: "Кострома",
        departureTime: "22:30",
        arrivalTime: "08:15",
        duration: "20 часов",
        date: "14 января",
        email: "info@rzd.ru",
        phone: "+7 (800) 775-00-00"
    ),
    Carrier(
        name: "ФГК",
        logo: "fgk",
        hasTransfer: false,
        transferCity: nil,
        departureTime: "01:15",
        arrivalTime: "09:00",
        duration: "9 часов",
        date: "15 января",
        email: "support@fgk.ru",
        phone: "+7 (495) 123-45-67"
    ),
    Carrier(
        name: "Урал логистика",
        logo: "ural",
        hasTransfer: false,
        transferCity: nil,
        departureTime: "12:30",
        arrivalTime: "21:00",
        duration: "9 часов",
        date: "16 января",
        email: "info@urallogistics.ru",
        phone: "+7 (343) 232-22-22"
    ),
    Carrier(
        name: "РЖД",
        logo: "rzd2",
        hasTransfer: true,
        transferCity: "Кострома",
        departureTime: "22:30",
        arrivalTime: "08:15",
        duration: "20 часов",
        date: "17 января",
        email: "info@rzd.ru",
        phone: "+7 (800) 775-00-00"
    ),
    Carrier(
        name: "РЖД",
        logo: "rzd",
        hasTransfer: false,
        transferCity: nil,
        departureTime: "10:00",
        arrivalTime: "18:30",
        duration: "8.5 часов",
        date: "17 января",
        email: "info@rzd.ru",
        phone: "+7 (800) 775-00-00"
    )
]
