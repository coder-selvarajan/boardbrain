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
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            
                            Image(systemName: "square.grid.2x2.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            
                            Image(systemName: "square.grid.2x2.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                            
                            Image(systemName: "square.grid.2x2.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.orange)
                            
                            Image(systemName: "square.grid.2x2.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.yellow)
                        }
                    }
                    
                    HStack {
                        Text("Timer Value (seconds)")
                        Slider(value: $timerValue, in: 5...120, step: 5)
                    }
                    HStack {
                        Text("Current Timer: \(Int(timerValue))s")
                    }
                }
            }
            .background(Color.white.opacity(20.0))
            
        }
        .scrollContentBackground(.hidden)
        .background(Color.white.opacity(20.0))
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
