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
        NavigationView {
            Form {
                Section(header: Text("Home Page Settings")) {
                    ColorPicker("Choose Color", selection: $selectedColor)
                    HStack {
                        Text("Timer Value (seconds)")
                        Slider(value: $timerValue, in: 5...120, step: 5)
                    }
                    HStack {
                        Text("Current Timer: \(Int(timerValue))s")
                    }
                }
                
                Section(header: Text("Logo Settings")) {
                    LogoPicker(selectedImage: $logoImage)
                }
            }
            .navigationTitle("Settings")
        }
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
