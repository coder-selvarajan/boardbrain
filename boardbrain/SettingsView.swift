//
//  Settings.swift
//  boardbrain
//
//  Created by Selvarajan on 26/04/24.
//

import SwiftUI

enum BoardTheme: Identifiable, CaseIterable, Codable {
    var id: Self { self }
    case gray, brown, blue, green
    
    var lightColor: Color {
        switch self {
        case .gray:
            return Color.white
        case .brown:
            return Color(hex: "#F0D9B5")
        case .blue:
            return Color(hex: "#DEE3E6")
        case .green:
            return Color(hex: "#EAECD0")
        }
    }
    var darkColor: Color {
        switch self {
        case .gray:
            return Color.gray
        case .brown:
            return Color(hex: "#B58863")
        case .blue:
            return Color(hex: "#8BA2AD")
        case .green:
            return Color(hex: "#729552")
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var selectedBoardTheme: BoardTheme = .gray
    @State private var selectedColor = Color.blue
    @State private var timerValue: Double = 30
    @State private var logoImage: Image = Image(systemName: "photo")
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    VStack(alignment: .leading) {
                        Text("Chessboard theme")
                        HStack (spacing: 25) {
                            ForEach(BoardTheme.allCases, id:\.self) { theme in
                                ThemeBoard(lightColor: theme.lightColor, darkColor: theme.darkColor)
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10.0)
                                    .overlay(
                                        (theme == selectedBoardTheme) ? RoundedRectangle(cornerRadius: 10).stroke(.red, lineWidth: 4)
                                        : nil
                                    )
                                    .onTapGesture { loc in
                                        selectedBoardTheme = theme
                                        themeManager.updateTheme(primary: theme.lightColor, secondary: theme.darkColor)
                                    }
                            }
                        }.padding(.vertical, 10)
                    }
                    HStack(alignment: .center, spacing: 30) {
                        Text("Game Timer")
                        Spacer()
                        TextField("Game Timer", value: $timerValue, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                        //                            .padding()
                    }
                    .padding(.vertical, 10)
                    
                }
            }
            .background(Color.white.opacity(20.0))
            
        }
        //        .scrollContentBackground(.hidden)
        //        .background(Color.white.opacity(20.0))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        
    }
}
