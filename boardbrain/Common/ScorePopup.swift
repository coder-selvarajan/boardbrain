//
//  ScorePopup.swift
//  boardbrain
//
//  Created by Selvarajan on 12/05/24.
//

import SwiftUI

struct ScorePopup: View {
    let trainingType: TrainingType
    let correctAttempts: Int
    let totalAttempts: Int
    let questionList: [GameIteration]
    let scoreModel: ScoreModel
    
    @Binding var gameEnded: Bool
    
    var body: some View {
        VStack {
            Text("Game over!")
                .font(.footnote)
                .foregroundColor(.black)
                .padding(.bottom, 5)
            
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
    }
}

//#Preview {
//    ScorePopup()
//}
