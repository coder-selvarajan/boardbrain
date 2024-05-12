//
//  ShareScore.swift
//  boardbrain
//
//  Created by Selvarajan on 10/05/24.
//
// Appstore short url for the app:
// https://apple.co/3UT2jaJ

import SwiftUI

struct ShareScoreButton: View {
    var trainingType: TrainingType
    var responseTime: String
    var scoreModel: ScoreModel
    
    @State private var isSharing = false
    
    var body: some View {
        Button {
            isSharing = true
        } label: {
            HStack(alignment: .center, spacing: 15) {
                Spacer()
                Image(systemName: "square.and.arrow.up")
                    .font(.headline)
                    .foregroundStyle(.black)
                Text("Share Score")
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.vertical, 15)
                Spacer()
            }
        }
        .background(.cyan.opacity(0.80))
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .sheet(isPresented: $isSharing, onDismiss: {
            print("Dismissed")
        }) {
            ActivityView(activityItems: [scoreText()])
        }
    }
    
    func scoreText() -> String {
        """
        🎉 Scored \(scoreModel.lastScore.correctAttempts)/\(scoreModel.lastScore.totalAttempts) in \(trainingType) Training on BoardBrain app! 🕒 \(responseTime)s response time!

        🔹 Avg. score as White: \(twoDigitFormat(value: scoreModel.avgScoreWhite))
        🔹 Avg. score as Black: \(twoDigitFormat(value: scoreModel.avgScoreBlack))

        Can you beat this? 🤔 Download and try: https://apple.co/3UT2jaJ #BoardBrain #ChessChallenge #Chess\(trainingType)Training
        """
    }
}

// UIViewControllerRepresentable wrapper
struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
    typealias UIViewControllerType = UIActivityViewController
}
