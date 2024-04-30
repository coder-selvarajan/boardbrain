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
            HomeView()
//            XChessBoardHome()
                .colorScheme(ColorScheme.dark)
                .environmentObject(ThemeManager())
        }
    }
}
