//
//  DisplayScoreView.swift
//  boardbrain
//
//  Created by Selvarajan on 12/05/24.
//

import SwiftUI

struct DisplayScoreView: View {
    let scoreModel: ScoreModel
    
    var body: some View {
        if (scoreModel.totalPlayBlack > 0 || scoreModel.totalPlayWhite > 0) {
            VStack(spacing: 5) {
                HStack(spacing: 2) {
                    Text(String(format: "Last Score (%@): %d / %d",
                                scoreModel.lastScoreAs == .white ? "W" : "B",
                                scoreModel.lastScore.correctAttempts,
                                scoreModel.lastScore.totalAttempts))
                    if let avgTime = scoreModel.lastScore.avgResponseTime {
                        Text("⏱️")
                            .font(.subheadline)
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                        Text(avgTime)
                        Text("s")
                    }
                }
                .font(.footnote)
                
                HStack(alignment: .bottom) {
                    Text("Average Score:")
                    
                    Image("king-w")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                    
                    Text(String(format: "%.2f  ", scoreModel.avgScoreWhite))
                    Image("king-b")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                    
                    Text(String(format: "%.2f", scoreModel.avgScoreBlack))
                }
                .font(.footnote)
            } //VStack
        } else {
            EmptyView()
        }
    }
}

//#Preview {
//    DisplayScoreView()
//}
