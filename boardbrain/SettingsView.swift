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
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    
    @AppStorage("hapticFeedback") private var hapticFeedbackEnabled = true
    
    @State private var selectedColor = Color.blue
    @State private var timerValue: Double = 30
    @State private var logoImage: Image = Image(systemName: "photo")
    
    @State private var selectedTraining: TrainingType? = nil
    @State private var showResetOptions: Bool = false
    @State private var showConfirmation: Bool = false
    
    @State private var showMessage: Bool = false
    
    var selectedTrainingType: String {
        if selectedTraining == nil {
            return "All"
        }
        
        return selectedTraining!.rawValue
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
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
                            Spacer()
                        }.padding(.vertical, 10)
                        
                    }
                    .padding()
                } // Section
                
                Section {
                    VStack {
                        Toggle(isOn: $hapticFeedbackEnabled) {
                            VStack(alignment: .leading) {
                                Text("Haptic Feedback")
                                Text("Receive subtle vibrations during game interactions")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                        }
                    } // VStack
                    .padding()
                } //Section
                
                //                Section(header: Text("Score Reset")) {
                Section {
                    VStack {
                        Button {
                            showMessage = false
                            showResetOptions = true
                        } label: {
                            HStack(spacing: 15) {
                                Spacer()
                                
                                Image(systemName: "arrow.clockwise")
                                Text("Reset Scores")
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.red)
                        .cornerRadius(10)
                        
                        
                        if showMessage {
                            Text("\(selectedTrainingType) scores have been reset successfully.")
                                .font(.caption)
                                .foregroundStyle(.yellow)
                            
                        }
                    } // VStack
                    .padding()
                } //Section
                
                
            }
//            .background(Color.white.opacity(20.0))
            
        } // VStack
        .background(Color.white.opacity(0.20))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .actionSheet(isPresented: $showResetOptions) {
            ActionSheet(title: Text("Choose a module to reset:"), buttons: [
                .default(Text("Coordinates Training"), action: {
                    selectedTraining = .Coordinates
                    showConfirmation = true
                }),
                .default(Text("Moves Training"), action: {
                    selectedTraining = .Moves
                    showConfirmation = true
                }),
                .default(Text("Colors Training"), action: {
                    selectedTraining = .Colors
                    showConfirmation = true
                }),
                .default(Text("All the above"), action: {
                    selectedTraining = nil
                    showConfirmation = true
                }),
                .cancel()
            ])
        }
        .alert(isPresented: $showConfirmation) {
            Alert(
                title: Text("Confirm Reset"),
                message: Text("Are you sure you want to reset \(selectedTrainingType) training scores?" ),
                primaryButton: .destructive(Text("Reset"), action: {
                    if (selectedTraining == nil) {
                        scoreViewModel.resetScore(for: TrainingType.Coordinates)
                        scoreViewModel.resetScore(for: TrainingType.Moves)
                        scoreViewModel.resetScore(for: TrainingType.Colors)
                    } else {
                        scoreViewModel.resetScore(for: selectedTraining!)
                    }
                    showMessage = true
                }),
                secondaryButton: .cancel()
            )
        }
        
        //        .confirmationDialog("Are you sure to reset score?",
        //                            isPresented: $confirmBox) {
        //            Button("Reset all scores?", role: .destructive) {
        //
        //                scoreViewModel.resetScore(for: TrainingType.Coordinates)
        //                scoreViewModel.resetScore(for: TrainingType.Moves)
        //                scoreViewModel.resetScore(for: TrainingType.Colors)
        //
        //                showMessage = true
        //            }
        //        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
