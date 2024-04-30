//
//  ThemeManager.swift
//  boardbrain
//
//  Created by Selvarajan on 29/04/24.
//

import Foundation
import SwiftUI

class ThemeManager: ObservableObject {
    @Published var boardColors: (Color, Color) = (.white, .gray)  // Default theme colors

    func updateTheme(primary: Color, secondary: Color) {
        boardColors = (primary, secondary)
        
        // here we might update the colors in user-defaults
    }
}
