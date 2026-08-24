//
//  StoriesViewerView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import SwiftUI

struct StoriesViewerView: View {
    @State private var viewModel: StoriesViewerViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(stories: [StoryItem], startIndex: Int, viewedIDs: Binding<Set<UUID>>) {
        _viewModel = State(initialValue: StoriesViewerViewModel(
            stories: stories,
            startIndex: startIndex,
            viewedIDs: viewedIDs
        ))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color.black.ignoresSafeArea()
                
                if let story = viewModel.currentStory {
                    Image(story.imageName)
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
                        
                        Text(story.parsedTitle)
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                        
                        if let description = story.parsedDescription {
                            Text(description)
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
                    .onTapGesture { viewModel.handleTap() }
                    .gesture(
                        DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                if value.translation.width < -50 { viewModel.nextStory() }
                                else if value.translation.width > 50 { viewModel.prevStory() }
                            }
                    )
                
                ProgressBar(numberOfSections: viewModel.stories.count, progress: viewModel.progress)
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
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .onChange(of: viewModel.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
    }
}
