//
//  StoriesViewerViewModel.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 24.08.2026.
//

import SwiftUI
import Combine

@Observable
final class StoriesViewerViewModel {
    let stories: [StoryItem]
    
    var currentIndex: Int
    var progress: CGFloat = 0
    var shouldDismiss: Bool = false
    
    private var timerPublisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    private var viewedIDsBinding: Binding<Set<UUID>>
    
    private let storyDuration: TimeInterval = 5.0
    private let tickInterval: TimeInterval = 0.05
    
    var currentStory: StoryItem? {
        guard stories.indices.contains(currentIndex) else { return nil }
        return stories[currentIndex]
    }
    
    init(stories: [StoryItem], startIndex: Int, viewedIDs: Binding<Set<UUID>>) {
        self.stories = stories
        self.currentIndex = startIndex
        self.viewedIDsBinding = viewedIDs
        self.timerPublisher = Timer.publish(every: tickInterval, on: .main, in: .common)
        
        if stories.count > 0 {
            self.progress = CGFloat(startIndex) / CGFloat(stories.count)
        }
    }
    
    // MARK: - User Actions
    
    func onAppear() {
        startTimer()
    }
    
    func onDisappear() {
        cancellable?.cancel()
    }
    
    func handleTap() {
        nextStory()
    }
    
    func nextStory() {
        guard let current = currentStory else { return }
        viewedIDsBinding.wrappedValue.insert(current.id)
        
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            resetTimerForNewStory()
        } else {
            shouldDismiss = true
        }
    }
    
    func prevStory() {
        if currentIndex > 0 {
            currentIndex -= 1
            resetTimerForNewStory()
        }
    }
    
    // MARK: - Timer Logic
    
    func updateProgress() {
        guard stories.count > 0 else { return }
        let step = (1.0 / CGFloat(stories.count)) / (storyDuration / tickInterval)
        let nextProgress = progress + step
        
        if nextProgress >= CGFloat(currentIndex + 1) / CGFloat(stories.count) {
            nextStory()
            return
        }
        
        progress = nextProgress
    }
    
    private func startTimer() {
        guard stories.count > 0 else { return }
        progress = CGFloat(currentIndex) / CGFloat(stories.count)
        timerPublisher = Timer.publish(every: tickInterval, on: .main, in: .common)
        cancellable = timerPublisher.autoconnect().sink { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    private func resetTimerForNewStory() {
        cancellable?.cancel()
        startTimer()
    }
}
