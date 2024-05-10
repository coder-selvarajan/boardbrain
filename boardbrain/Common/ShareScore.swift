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
    var score: Int
    @State private var isSharing = false

    var body: some View {
        Button {
            isSharing = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "square.and.arrow.up")
                Text("Share Score")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.vertical, 10)
            }
        }
//        .background(.black.opacity(0.10))
        .frame(maxWidth: .infinity)
        .cornerRadius(10)
        .padding(.bottom)
        .sheet(isPresented: $isSharing, onDismiss: {
            print("Dismissed")
        }) {
            ActivityView(activityItems: [scoreText()])
        }
        
    }

    func scoreText() -> String {
        """
        🎉 I scored 15/16 points on BoardBrain app!

        🔹 Average score as White: 10.54
        🔹 Average score as Black: 9.10

        Can you beat my score? 🤔 Challenge yourself and download BoardBrain from the App Store:
        https://apple.co/3UT2jaJ #BoardBrain #ChessChallenge #ChessboardTrainer
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
