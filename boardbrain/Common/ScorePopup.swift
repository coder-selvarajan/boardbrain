//
//  ScorePopup.swift
//  boardbrain
//
//  Created by Selvarajan on 12/05/24.
//

import SwiftUI
import ConfettiSwiftUI

struct ScorePopup: View {
    let trainingType: TrainingType
    let correctAttempts: Int
    let totalAttempts: Int
    let questionList: [GameIteration]
    let scoreModel: ScoreModel
    
    @Binding var gameEnded: Bool
    @State var confettiTrigger: Int = 0
    @State var congratsMessage: String = ""
    
    func eligible4ConfettiAnimation() -> Bool {
        if scoreModel.lastScoreAs == .white {
            if scoreModel.totalPlayWhite == scoreModel.whiteAvgScoreCrossedAt {
                congratsMessage = "Congratulations! 👏🏻 \nYou have achieved the common average score!"
                return true
            }
            
            if scoreModel.whiteAvgScoreCrossedAt! > 0 && scoreModel.lastScoreCrossedBestScore! {
                congratsMessage = "Congratulations! 🎉 \nYou have beaten your best score. Keep going!"
                return true
            }
        } else { //black
            if scoreModel.totalPlayBlack == scoreModel.blackAvgScoreCrossedAt {
                congratsMessage = "Congratulations! 👏🏻 \nYou have achieved the common average score!"
                return true
            }
            
            if scoreModel.blackAvgScoreCrossedAt! > 0 && scoreModel.lastScoreCrossedBestScore! {
                congratsMessage = "Congratulations! 🎉 \nYou have beaten your best score. Keep going!"
                return true
            }
        }

        return false
    }
    
    var body: some View {
        ZStack {
            VStack {
                if (congratsMessage == "") {
                    Text("Game over!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                } else {
                    Text(congratsMessage)
                        .font(.footnote)
                        .foregroundColor(.indigo)
                        .padding(.bottom, 5)
                    
                    Divider()
                }
                
                
                Text("Score: \(correctAttempts)/\(totalAttempts)")
                    .font(.title)
                    .foregroundColor(.green)
                HStack {
                    Text("Avg. Resp. Time")
                        .font(.footnote)
                        .foregroundColor(.black)
                    Text("\(averageResponseTime(iterationList: questionList))")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("sec")
                        .font(.footnote)
                        .foregroundColor(.black)
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Average Score: ")
                        .foregroundColor(.gray)
                    Text(String(format: "as White:  %.2f \nas Black:  %.2f ",
                                scoreModel.avgScoreWhite, scoreModel.avgScoreBlack))
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.bottom)
                    
                    Text("Best Score: ")
                        .foregroundColor(.gray)
                    Text("as White:  \(scoreModel.bestScoreWhite.correctAttempts) / \(scoreModel.bestScoreWhite.totalAttempts) \nas Black:  \(scoreModel.bestScoreBlack.correctAttempts) / \(scoreModel.bestScoreBlack.totalAttempts)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.25))
                .cornerRadius(15)
                .padding(.bottom)
                .onAppear() {
                    if eligible4ConfettiAnimation() {
                        confettiTrigger += 1
                    }
                }
                
                ShareScoreButton(trainingType: trainingType,
                                 responseTime: averageResponseTime(iterationList: questionList),
                                 scoreModel: scoreModel)
                
                
            }
            .padding(25)
            .background(.white)
            .cornerRadius(15)
            .frame(width: 250)
            .overlay(
                CloseButton() {
                    gameEnded = false
                }, alignment: .topTrailing
            )
            .overlay {
                ConfettiCannon(counter: $confettiTrigger, num: 50,
                               colors: [.red, .green, .blue, .yellow],
                               confettiSize: 10.0, rainHeight: 600.0, radius: 400.0)
            }
            
        }
    }
}

//#Preview {
//    ScorePopup()
//}
