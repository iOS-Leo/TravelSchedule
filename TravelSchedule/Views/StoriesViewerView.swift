//
//  StoriesViewerView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import SwiftUI
import Combine

struct StoriesViewerView: View {
    let stories: [StoryItem]
    @Binding var viewedIDs: Set<UUID>
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentIndex: Int
    @State private var progress: CGFloat = 0
    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    
    private let storyDuration: TimeInterval = 5.0
    private let tickInterval: TimeInterval = 0.05
    
    init(stories: [StoryItem], startIndex: Int, viewedIDs: Binding<Set<UUID>>) {
        self.stories = stories
        _currentIndex = State(initialValue: startIndex)
        self._viewedIDs = viewedIDs
        
        _timer = State(initialValue: Timer.publish(every: 0.05, on: .main, in: .common))
        
        if startIndex > 0 {
            _progress = State(initialValue: CGFloat(startIndex) / CGFloat(stories.count))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()
                
                if stories.indices.contains(currentIndex) {
                    Image(stories[currentIndex].imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()
                        
                        let parts = stories[currentIndex].title.components(separatedBy: "\n")
                        let titlePart = parts.first ?? ""
                        let descPart = parts.count > 1 ? parts[1] : ""
                        
                        Text(titlePart)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        
                        if !descPart.isEmpty {
                            Text(descPart)
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(3)
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 60)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { handleTap() }
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                if value.translation.width < -50 { nextStory() }
                                else if value.translation.width > 50 { prevStory() }
                            }
                    )
                
                ProgressBar(numberOfSections: stories.count, progress: progress)
                    .padding(.horizontal, 16)
                    .padding(.top, 60)
                
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image("closeButton")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 70)
            }
        }
        .statusBarHidden(true)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .onReceive(timer) { _ in
            updateProgress()
        }
    }

    private func updateProgress() {
        let step = (1.0 / CGFloat(stories.count)) / (storyDuration / tickInterval)
        let nextProgress = progress + step
        
        if nextProgress >= CGFloat(currentIndex + 1) / CGFloat(stories.count) {
            nextStory()
            return
        }
        
        progress = nextProgress
    }
    
    private func handleTap() {
        nextStory()
    }
    
    private func nextStory() {
        viewedIDs.insert(stories[currentIndex].id)
        
        if currentIndex < stories.count - 1 {
            currentIndex += 1
        } else {
            dismiss()
            return
        }
        
        resetTimerForNewStory()
    }
    
    private func prevStory() {
        if currentIndex > 0 {
            currentIndex -= 1
            resetTimerForNewStory()
        }
    }
    
    private func resetTimerForNewStory() {
        cancellable?.cancel()
        progress = CGFloat(currentIndex) / CGFloat(stories.count)
        timer = Timer.publish(every: tickInterval, on: .main, in: .common)
        cancellable = timer.connect()
    }
    
    private func startTimer() {
        progress = CGFloat(currentIndex) / CGFloat(stories.count)
        timer = Timer.publish(every: tickInterval, on: .main, in: .common)
        cancellable = timer.connect()
    }
}
