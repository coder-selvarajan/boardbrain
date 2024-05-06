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
    var body: some Scene {
        WindowGroup {
            MainView()
                .colorScheme(ColorScheme.dark)
                .environmentObject(ThemeManager())
                .environmentObject(ScoreViewModel())
        }
    }
}
