//
//  MovesIntroPopup.swift
//  boardbrain
//
//  Created by Selvarajan on 02/05/24.
//

import SwiftUI

struct MovesIntroPopup: View {
    @Binding var showIntroModal: Bool
    @AppStorage("showMovesIntro") private var showIntro: Bool = true
    
    let closeCallBack: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text("Game Intro: ")
                    .font(.body)
                    .fontWeight(.bold)

                Text("Moves training module helps to explore various piece movements in an interactive format.")
                    .font(.callout)
                    .padding(.vertical, 10)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading) {
                    Text("How it works?")
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "hand.draw")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("Random targets will be set for a random piece on the board. Drag the piece to the right square and earn a point.")
                            .font(.subheadline)
//                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "stopwatch")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("The game continues for a duration of 30 seconds.")
                            .font(.subheadline)
//                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "chart.xyaxis.line")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("After the game concludes, your total and average scores(from previous attempts) will be shown.")
                            .lineLimit(nil)
                            .font(.subheadline)
//                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(10.0)
                
                Toggle("Don't show the intro again", isOn: $showIntro)
                    .font(.callout)
                    .onChange(of: showIntro) { value, _ in
                        showIntroModal = !value // Close the modal when user chooses to not show it again
                    }
                    .padding(.vertical, 10)
                
                HStack {
                    Spacer()
                    Button("Get started") {
                        showIntroModal = false // Close the modal when the user starts the training
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.vertical, 15)
                    .background(Color.cyan.opacity(0.85))
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                
            } //VStack
            .padding(20)
            .background(.white)
            .foregroundColor(.black)
            .cornerRadius(15)
            .frame(width: UIScreen.main.bounds.size.width - 60)
            .overlay(
                Button {
                    showIntroModal = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                }
                .padding([.top, .trailing], 15),
                alignment: .topTrailing
            )
        } // ZStack
    }
}

//#Preview {
//    MovesIntroPopup()
//}
