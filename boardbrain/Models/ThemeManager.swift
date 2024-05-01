//
//  ThemeManager.swift
//  boardbrain
//
//  Created by Selvarajan on 29/04/24.
//

import Foundation

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var boardColors: (Color, Color) = (.clear, .clear)
    @Published var boardTheme: BoardTheme = .green

    init() {
        // Set the initial value
        let theme = loadTheme()
        boardColors = (theme.0, theme.1)
        boardTheme = theme.2
    }

    func updateTheme(primary: Color, secondary: Color, theme: BoardTheme) {
        boardColors = (primary, secondary)
        boardTheme = theme
        
        saveTheme()
    }
    
    private func saveTheme() {
        // Convert Colors to a storable format and save to UserDefaults
        UserDefaults.standard.set(encodeColor(color: boardColors.0), forKey: "primaryColor")
        UserDefaults.standard.set(encodeColor(color: boardColors.1), forKey: "secondaryColor")
        UserDefaults.standard.set(boardTheme.rawValue, forKey: "boardTheme")
    }
    
    private func loadTheme() -> (Color, Color, BoardTheme) {
        // Load colors from UserDefaults or default if not available
        guard   let primaryColor = UserDefaults.standard.string(forKey: "primaryColor"),
                let secondaryColor = UserDefaults.standard.string(forKey: "secondaryColor"),
                let boardTheme = UserDefaults.standard.string(forKey: "boardTheme")
        else { return (.white, .gray, .gray) }
        
        return (decodeColor(from: primaryColor),
                decodeColor(from: secondaryColor),
                BoardTheme(rawValue: boardTheme)! )
    }

    private func encodeColor(color: Color) -> String {
        // Convert Color to a storable format, such as HEX string
        UIColor(color).toHex() ?? "#FFFFFF"
    }

    private func decodeColor(from hex: String) -> Color {
        UIColor(hex: hex).map { Color($0) } ?? .gray
    }
}

extension UIColor {
    // Helper to convert UIColor to HEX string
    func toHex() -> String? {
        let components = cgColor.components ?? [0, 0, 0]
        let r = components[0]
        let g = components.count > 1 ? components[1] : 0
        let b = components.count > 2 ? components[2] : 0
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }

    // Helper to create UIColor from HEX string
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        let start = hex.index(hex.startIndex, offsetBy: hex.hasPrefix("#") ? 1 : 0)
        let hexColor = String(hex[start...])

        if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000FF) / 255
                a = 1.0

                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        return nil
    }
}
