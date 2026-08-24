//
//  AgreementWebView.swift
//  TravelSchedule
//
//  Created by Leo Gabuev on 20.08.2026.
//

import SwiftUI
import WebKit

struct AgreementWebViewContainer: View {
    @Bindable var viewModel: SettingsViewModel
    let url: URL
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AgreementWebView(
                    url: url,
                    isDarkMode: viewModel.isDarkModeEnabled,
                    onFinishLoading: viewModel.webViewDidFinishLoading
                )
                .ignoresSafeArea()
                
                if viewModel.isWebViewLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Соглашение")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .font(Constants.Fonts.bodyRegular.bold())
                }
            }
        }
    }
}

struct AgreementWebView: UIViewRepresentable {
    let url: URL
    let isDarkMode: Bool
    var onFinishLoading: (() -> Void)?
    
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
        init(_ parent: AgreementWebView) { self.parent = parent }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onFinishLoading?()
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation?, withError error: Error) {
            parent.onFinishLoading?()
            print("WebView error: \(error.localizedDescription)")
        }
    }
}
