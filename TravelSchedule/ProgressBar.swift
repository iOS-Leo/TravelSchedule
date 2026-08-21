//
//  ProgressBar.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import SwiftUI

extension CGFloat {
    static let progressBarCornerRadius: CGFloat = 6
    static let progressBarHeight: CGFloat = 6
}

extension Color {
    static let progressBarFill: Color = .blue
}

struct ProgressBar: View {
    let numberOfSections: Int
    let progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(width: geometry.size.width, height: .progressBarHeight)
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: .progressBarCornerRadius)
                    .frame(
                        width: min(progress * geometry.size.width, geometry.size.width),
                        height: .progressBarHeight
                    )
                    .foregroundColor(.progressBarFill)
            }
            .mask {
                MaskView(numberOfSections: numberOfSections)
            }
        }
    }
}

private struct MaskView: View {
    let numberOfSections: Int
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
    }
}

private struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: .progressBarCornerRadius)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: .progressBarHeight)
            .foregroundStyle(.white)
    }
}
