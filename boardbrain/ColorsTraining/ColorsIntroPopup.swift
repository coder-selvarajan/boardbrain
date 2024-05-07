//
//  ColorsIntroPopup.swift
//  boardbrain
//
//  Created by Selvarajan on 02/05/24.
//

import SwiftUI

struct ColorsIntroPopup: View {
    @Binding var showIntroModal: Bool
    @Binding var hideControls: Bool
    @AppStorage("showGameIntro") private var showIntro: Bool = true
    
    let closeCallBack: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text("Game Intro: ")
                    .font(.body)
                    .fontWeight(.bold)
//                Text("Coordinates Training")
//                    .font(.caption)
                                
                Text("Colors training module helps to enhance your ability to quickly recognize the colors of different squares on the chessboard, a vital skill for strategic planning.")
                    .font(.callout)
                    .padding(.vertical, 10)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading) {
                    Text("How it works?")
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    processStepView(imageName: "rectangle.filled.and.hand.point.up.left",
                                    desc: "A random square will be highlighted on the board; select the correct color of the square to earn a point.")
                    
                    Divider()
                    
                    processStepView(imageName: "stopwatch",
                                    desc: "The game lasts 30 seconds.")
                    
                    Divider()
                    
                    processStepView(imageName: "chart.xyaxis.line",
                                    desc: "See your total and average scores at the end.")
                }
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(10.0)
                .padding(.bottom, 5)
                
                if !hideControls {
                    Toggle("Don't show the intro again", isOn: Binding(
                        get: { !showIntro },
                        set: { showIntro = !$0 }
                    ))
                        .font(.callout)
                        .onChange(of: showIntro) { value, _ in
                            showIntroModal = !value // Close the modal when user chooses to not show it again
                        }
                        .padding(.vertical, 10)
                    
//                    HStack {
//                        Spacer()
//                        Button("Get started") {
//                            showIntroModal = false // Close the modal when the user starts the training
//                        }
//                        .foregroundColor(.black)
//                        .padding(.horizontal)
//                        .padding(.vertical, 15)
//                        .background(Color.cyan.opacity(0.85))
//                        .cornerRadius(10)
//                        
//                        Spacer()
//                    }
//                    .padding(.vertical, 10)
                }
                
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
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                }
                .padding([.top, .trailing], 10),
                alignment: .topTrailing
            )
        } // ZStack
    }
}

//#Preview {
//    ColorsIntroPopup()
//}
