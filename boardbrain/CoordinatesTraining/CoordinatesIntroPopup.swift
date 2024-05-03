//
//  CoordinatesIntroPopup.swift
//  boardbrain
//
//  Created by Selvarajan on 02/05/24.
//

import SwiftUI

struct processStepView: View {
    let imageName: String
    let desc: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 20, height: 20)
            
            Text(desc)
                .font(.subheadline)
        }
    }
}

struct CoordinatesIntroPopup: View {
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
                
                Text("Coordinates training module helps to quickly identify chessboard coordinates through interactive challenges.")
                    .font(.callout)
                    .padding(.vertical, 10)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading) {
                    Text("How it works?")
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    processStepView(imageName: "rectangle.and.hand.point.up.left.filled",
                                    desc: "Random square coordinates will appear on the screen; tap each square to earn a point.")
                    
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
                    Toggle("Don't show the intros again", isOn: Binding(
                        get: { !showIntro },
                        set: { showIntro = !$0 }
                    ))
                        .font(.callout)
                        .onChange(of: showIntro) { value, _ in
                            showIntroModal = !value // Close the modal when user chooses to not show it again
                        }
                        .padding(.vertical, 10)
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
                .padding([.top, .trailing], 15),
                alignment: .topTrailing
            )
        } // ZStack
    }
}

//#Preview {
//    CoordinatesIntroPopup()
//}
