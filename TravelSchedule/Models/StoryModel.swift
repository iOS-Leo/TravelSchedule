//
//  StoryModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import Foundation

// MARK: - Story Model
struct StoryItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    var isViewed: Bool = false
    
    var parsedTitle: String {
        title.components(separatedBy: "\n").first ?? ""
    }
    
    var parsedDescription: String? {
        let parts = title.components(separatedBy: "\n")
        return parts.count > 1 ? parts[1] : nil
    }
}

let mockStories: [StoryItem] = [
    StoryItem(
        title: "Text Text Text Text Text Text Text Text Text Text Text Text Text\nText Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
        imageName: "stub1"
    ),
    StoryItem(
        title: "Text Text Text Text Text Text Text Text Text Text Text Text Text\nText Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
        imageName: "stub2"
    ),
    StoryItem(
        title: "Text Text Text Text Text Text Text Text Text Text Text Text Text\nText Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
        imageName: "stub3"
    ),
    StoryItem(
        title: "Text Text Text Text Text Text Text Text Text Text Text Text Text\nText Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
        imageName: "stub4"
    )
]
