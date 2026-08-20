//
//  AgreementWebView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import SwiftUI
import WebKit

struct AgreementWebView: UIViewRepresentable {
    let url: URL
    let isDarkMode: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let themeScript = """
            document.documentElement.style.colorScheme = '\(isDarkMode ? "dark" : "light")';
            document.body.style.backgroundColor = '\(isDarkMode ? "#000000" : "#ffffff")';
            document.body.style.color = '\(isDarkMode ? "#ffffff" : "#000000")';
        """
        uiView.evaluateJavaScript(themeScript)
        
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AgreementWebView
        
        init(_ parent: AgreementWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation?, withError error: Error) {
            print("WebView error: \(error.localizedDescription)")
        }
    }
}
