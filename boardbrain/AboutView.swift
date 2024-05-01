//
//  AboutView.swift
//  boardbrain
//
//  Created by Selvarajan on 01/05/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("BoardBrain")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("BoardBrain is an app designed to help both novice and experienced chess players improve their skills. It offers interactive games and exercises that focus on mastering chessboard coordinates, understanding piece movements, and recognizing square colors.")
                    .font(.body)
                
                Divider()
                
                Text("Features")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 10) {
                    FeatureView(icon: "square.grid.2x2", title: "Coordinates Training", description: "Learn and practice identifying the correct coordinates on the chessboard.")
                    FeatureView(icon: "crown", title: "Piece Movement Training", description: "Explore various piece movements in an interactive format.")
                    FeatureView(icon: "square.righthalf.filled", title: "Square Color training", description: "Enhance your ability to quickly recognize the colors of different squares on the chessboard, a vital skill for strategic planning.")
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("App Information")
                        .font(.body)
                        .fontWeight(.semibold)
                    Text("BoardBrain is an ad-free app that requires no internet connectivity. It does not require access to any information from the user's phone.")
                        .font(.caption)
                        .padding(.bottom)
                    Text("Technologies used: SwiftUI & SwiftData")
                        .font(.caption)
                    Link("Developer Website", destination: URL(string: "https://selvarajan.in")!)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color.white.opacity(0.20))
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    }
}

struct FeatureView: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
                .padding()
                .background(Circle().fill(Color.white.opacity(0.8)))
                .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    AboutView()
}
