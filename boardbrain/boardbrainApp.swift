//
//  boardbrainApp.swift
//  boardbrain
//
//  Created by Selvarajan on 06/04/24.
//

import SwiftUI
import SwiftData

@main
struct boardbrainApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .colorScheme(ColorScheme.dark)
        }
    }
}
