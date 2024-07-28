//
//  boardbrainApp.swift
//  boardbrain
//
//  Created by Selvarajan on 06/04/24.
//

import SwiftUI
import SwiftData
import TelemetryDeck

@main
struct BoardBrainApp: App {
    init() {
        let config = TelemetryDeck.Config(appID: "D7026E86-0893-4BF3-9123-5B0C72904EF4")
        TelemetryDeck.initialize(config: config)
        
        TelemetryDeck.signal(
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
                .onAppear(){
                    let uiAppClass = UIApplication.self
                    let currentSendEvent = class_getInstanceMethod(uiAppClass, #selector(uiAppClass.sendEvent))
                    let newSendEvent = class_getInstanceMethod(uiAppClass, #selector(uiAppClass.newSendEvent))
                    method_exchangeImplementations(currentSendEvent!, newSendEvent!)
                    print("Swizzlling called")
                }
        }
    }
}
