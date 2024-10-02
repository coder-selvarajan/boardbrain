//
//  boardbrainApp.swift
//  boardbrain
//
//  Created by Selvarajan on 06/04/24.
//

import SwiftUI
import SwiftData

@main
struct BoardBrainApp: App {
    init() {
        // SwiftUI Analytics instrumentation
        instrumentWithSwiftUIAnalytics()
        
        // AppLaunch signals to Analytics tool
        AnalyticsManager.shared.logEvent(
            "App Launched",
            parameters: [
                "app": "BoardBrain",
                "colorTheme": "dark mode",
                "event": "app_load"
            ]
        )
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .colorScheme(ColorScheme.dark)
                .environmentObject(ThemeManager())
                .environmentObject(ScoreViewModel())
        }
    }
}

func instrumentWithSwiftUIAnalytics(){
    DispatchQueue.main.async {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootView = windowScene.windows.first?.rootViewController?.view {
            rootView.accessibilityActivate()
            print("Activating accessibility info")
        } else {
            print("No accessible windows found.")
        }
    }
    
    // SwiftUI Analytics
    let uiAppClass = UIApplication.self
    let currentSendEvent = class_getInstanceMethod(uiAppClass, #selector(uiAppClass.sendEvent))
    let newSendEvent = class_getInstanceMethod(uiAppClass, #selector(uiAppClass.newSendEvent))
    method_exchangeImplementations(currentSendEvent!, newSendEvent!)
    print("Swizzlling called")
}
