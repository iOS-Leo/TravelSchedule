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
    Carrier(name: "РЖД", logo: "train.side.front.car", hasTransfer: true, transferCity: "Кострома", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", date: "14 января"),
    Carrier(name: "ФГК", logo: "tram.fill", hasTransfer: false, transferCity: nil, departureTime: "01:15", arrivalTime: "09:00", duration: "9 часов", date: "15 января"),
    Carrier(name: "Урал логистика", logo: "drop.fill", hasTransfer: false, transferCity: nil, departureTime: "12:30", arrivalTime: "21:00", duration: "9 часов", date: "16 января"),
    Carrier(name: "РЖД", logo: "train.side.front.car", hasTransfer: true, transferCity: "Кострома", departureTime: "22:30", arrivalTime: "08:15", duration: "20 часов", date: "17 января"),
    Carrier(name: "РЖД", logo: "train.side.front.car", hasTransfer: false, transferCity: nil, departureTime: "10:00", arrivalTime: "18:30", duration: "8.5 часов", date: "17 января")
]
