//
//  Settings.swift
//  boardbrain
//
//  Created by Selvarajan on 26/04/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedColor = Color.blue
    @State private var timerValue: Double = 30
    @State private var logoImage: Image = Image(systemName: "photo")

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Home Page Settings")) {
                    VStack(alignment: .leading) {
                        Text("Chessboard theme")
                        HStack (spacing: 15) {
                            ThemeBoard(lightColor: Color.white, darkColor: Color.gray)
                                .frame(width: 50, height: 50)
                            ThemeBoard(lightColor: Color.white, darkColor: Color.brown)
                                .frame(width: 50, height: 50)
                            ThemeBoard(lightColor: Color.white, darkColor: Color.green)
                                .frame(width: 50, height: 50)
                            ThemeBoard(lightColor: Color.white, darkColor: Color.blue)
                                .frame(width: 50, height: 50)
                        }
                    }
                    HStack(alignment: .center) {
                        Text("Game Timer")
                        Spacer()
                        TextField("Game Timer", value: $timerValue, format: .number)
                            .textFieldStyle(.roundedBorder)
//                            .padding()
                    }
                    
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

struct LogoPicker: View {
    @Binding var selectedImage: Image

    var body: some View {
        HStack {
            selectedImage
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Button("Change Logo") {
                // Implement the logic to change the logo
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
