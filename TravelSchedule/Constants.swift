//
//  Constants.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 28.07.2026.
//


import SwiftUI

enum Constants {
    
    // MARK: - Размеры и Отступы (Layout)
    enum Layout {
        static let searchBarHeight: CGFloat = 36.0
        static let listRowHeight: CGFloat = 60.0
        static let searchToListPadding: CGFloat = 16.0
        static let horizontalPadding: CGFloat = 16.0
        static let searchInnerPadding: CGFloat = 12.0
        static let searchCornerRadius: CGFloat = 10.0
        static let backButtonIconSize: CGFloat = 17.0
        static let chevronIconSize: CGFloat = 14.0
        
        static let mainTitleFontSize: CGFloat = 24.0
        static let mainButtonHeight: CGFloat = 60.0
        static let mainButtonCornerRadius: CGFloat = 16.0
        static let listBottomPadding: CGFloat = 90.0
        static let emptyStateSpacerHeight: CGFloat = 100.0
    }
    
    // MARK: - Шрифты (Fonts)
    enum Fonts {
        static let bodyRegular = Font.system(size: 17, weight: .regular)
        static let titleBold = Font.system(size: 20, weight: .bold)
        static let backButtonFont = Font.system(size: Layout.backButtonIconSize, weight: .semibold)
        static let chevronFont = Font.system(size: Layout.chevronIconSize, weight: .semibold)
    }
    
    // MARK: - Тексты (Strings)
    enum Strings {
        static let searchPlaceholder = "Введите запрос"
        static let cityNotFound = "Город не найден"
        static let stationNotFound = "Станция не найдена"
        static let cityPickerTitle = "Выбор города"
        static let stationPickerTitle = "Выбор станции"
        static let departurePlaceholder = "Откуда"
        static let destinationPlaceholder = "Куда"
        static let noCarriersFound = "Вариантов нет"
        static let filterButtonTitle = "Уточнить время"
        static let departureTimeSectionTitle = "Время отправления"
        static let transferSectionTitle = "Показывать варианты с пересадками"
        static let applyButtonTitle = "Применить"
        static let findButtonTitle = "Найти"
    }
    
    // MARK: - Иконки (System Images)
    enum Icons {
        static let search = "magnifyingglass"
        static let clearText = "xmark.circle.fill"
        static let back = "chevron.left"
        static let forward = "chevron.right"
        static let checkboxSelected = "checkmark.square.fill"
        static let checkboxUnselected = "square"
        static let radioButtonSelected = "largecircle.fill.circle"
        static let radioButtonUnselected = "circle"
        static let swap = "arrow.2.squarepath"
    }
    
    enum ErrorStrings {
        static let noInternet = "Нет интернета"
        static let serverError = "Ошибка сервера"
    }
    
    // MARK: - Имена Ассетов (Картинок)
    enum ImageAssets {
        static let noInternet = "noInternet"
        static let serverError = "serverError"
        static let launchScreen = "launchScreen"
    }
    
    enum FilterStrings {
        static let morning = "Утро 06:00 — 12:00"
        static let afternoon = "День 12:00 — 18:00"
        static let evening = "Вечер 18:00 — 00:00"
        static let night = "Ночь 00:00 — 06:00"
        
        static let transferYes = "Да"
        static let transferNo = "Нет"
    }
    
    enum Colors {
        static let mainBackgroundName = "mainBackground"
        static let mainBackground = Color(mainBackgroundName)
    }
}
