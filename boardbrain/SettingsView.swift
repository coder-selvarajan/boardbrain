//
//  Settings.swift
//  boardbrain
//
//  Created by Selvarajan on 26/04/24.
//

import SwiftUI

enum BoardTheme: String, Identifiable, CaseIterable, Codable {
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
    
    @ObservedObject var coordinatesScoreVM = ScoreViewModel(type: TrainingType.Coordinates)
    @ObservedObject var movesScoreVM = ScoreViewModel(type: TrainingType.Moves)
    @ObservedObject var colorsScoreVM = ScoreViewModel(type: TrainingType.Colors)
    
    
    //    @State private var selectedBoardTheme: BoardTheme = .gray
    @State private var selectedColor = Color.blue
    @State private var timerValue: Double = 30
    @State private var logoImage: Image = Image(systemName: "photo")
    
    @State private var confirmBox: Bool = false
    @State private var showMessage: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Theme Setting")) {
                    VStack(alignment: .leading) {
                        Text("Choose Board theme :")
                        HStack (spacing: 25) {
                            ForEach(BoardTheme.allCases, id:\.self) { theme in
                                ThemeBoard(lightColor: theme.lightColor, darkColor: theme.darkColor)
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(5)
                                    .background(content: {
                                        RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2)
                                    })
                                    .overlay(
                                        (theme == themeManager.boardTheme) ? RoundedRectangle(cornerRadius: 5).stroke(.red, lineWidth: 5)
                                        : nil
                                    )
                                    .onTapGesture { loc in
                                        //                                        selectedBoardTheme = theme
                                        themeManager.updateTheme(primary: theme.lightColor,
                                                                 secondary: theme.darkColor,
                                                                 theme: theme)
                                    }
                            }
                        }.padding(.vertical, 10)
                    }
                    
                    //                    HStack(alignment: .center, spacing: 30) {
                    //                        Text("Game Timer")
                    //                        Spacer()
                    //                        TextField("Game Timer", value: $timerValue, format: .number)
                    //                            .textFieldStyle(.roundedBorder)
                    //                            .frame(width: 100)
                    //                    }
                    //                    .padding(.vertical, 10)
                    
                } // Section
                
                Section(header: Text("Score Reset")) {
                    VStack {
                        Button {
                            //
                        } label: {
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title3)
                                    .foregroundColor(.black.opacity(0.75))
                                
                                Text("Reset scores")
                                    .font(.body)
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(20)
                            .frame(height: 50)
                            .background(.white.opacity(0.8))
                            .cornerRadius(10.0)
                            .onTapGesture {
                                confirmBox = true
                            }
                        }
                        Text(showMessage ? "All scores reset successfully" : "")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                        
//                        Button {
//                            //
//                        } label: {
//                            HStack(alignment: .center, spacing: 10) {
//                                Image(systemName: "arrow.clockwise")
//                                    .font(.title3)
//                                    .foregroundColor(.black.opacity(0.75))
//                                
//                                Text("Reset - Moves score")
//                                    .font(.body)
//                                    .foregroundColor(.black)
//                                
//                                Spacer()
//                            }
//                            .padding(.horizontal, 20)
//                            .frame(height: 40)
//                            .background(.white.opacity(0.8))
//                            .cornerRadius(10.0)
//                            .onTapGesture {
//                                confirmBoxForMovesScoreReset = true
//                            }
//                        }
//                        .padding(.vertical)
//                        
//                        Button {
//                            //
//                        } label: {
//                            HStack(alignment: .center, spacing: 10) {
//                                Image(systemName: "arrow.clockwise")
//                                    .font(.title3)
//                                    .foregroundColor(.black.opacity(0.75))
//                                
//                                Text("Reset - Colors score")
//                                    .font(.body)
//                                    .foregroundColor(.black)
//                                
//                                Spacer()
//                            }
//                            .padding(.horizontal, 20)
//                            .frame(height: 40)
//                            .background(.white.opacity(0.8))
//                            .cornerRadius(10.0)
//                            .onTapGesture {
//                                confirmBoxForColorsScoreReset = true
//                            }
//                        }
                        
                    } // VStack
                    .padding(.vertical)
                } //Section
            }
            .background(Color.white.opacity(20.0))
            
        } // VStack
        .background(Color.white.opacity(0.20))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .confirmationDialog("Are you sure to reset score?",
                            isPresented: $confirmBox) {
            Button("Reset all scores?", role: .destructive) {
                coordinatesScoreVM.resetScore()
                movesScoreVM.resetScore()
                colorsScoreVM.resetScore()
                
                showMessage = true
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
