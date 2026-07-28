//
//  ContentView.swift
//  Travel Schedule
//
//  Created by Leo Gabuev on 23.07.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashView {
                withAnimation {
                    showSplash = false
                }
            }
        } else {
            MainTabView()
        }
    }
}

struct SplashView: View {
    let onFinish: () -> Void
    
    var body: some View {
        Image("splashScreen")
            .resizable()
        
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    onFinish()
                }
            }
    }
}

#Preview {
    ContentView()
}
