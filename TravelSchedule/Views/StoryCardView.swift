//
//  StoryCardView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import SwiftUI

struct StoryCardView: View {
    let story: StoryItem
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(story.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 92, height: 140)
                .clipped()
                .cornerRadius(16)
                .opacity(story.isViewed ? 0.5 : 1.0)
            if !story.isViewed {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width: 92, height: 140)
            }
            
            Text(story.title)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white)
                .tracking(0.4)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
                .frame(width: 92, alignment: .leading)
        }
        .onTapGesture { onTap() }
    }
}
