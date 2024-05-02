//
//  CoordinatesIntroPopup.swift
//  boardbrain
//
//  Created by Selvarajan on 02/05/24.
//

import SwiftUI

struct CoordinatesIntroPopup: View {
    @Binding var showIntroModal: Bool
    @AppStorage("showCoordinatesIntro") private var showIntro: Bool = true
    
    let closeCallBack: (() -> Void)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Text("Game Intro!")
                    .font(.body)
//                Text("Coordinates Training")
//                    .font(.caption)
                //                .fontWeight(.bold)
                
                Divider()
                Text("Coordinates training module helps to quickly identify chessboard coordinates through interactive challenges.")
                    .font(.footnote)
                    .padding(.vertical, 10)
                    .fixedSize(horizontal: false, vertical: true)
                
                VStack(alignment: .leading) {
                    Text("How it works?")
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                    
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "rectangle.and.hand.point.up.left.filled")
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        Text("Random square coordinates will appear on the screen. Tap each square to earn a point.")
                            .font(.footnote)
//                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "stopwatch")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("The game continues for a duration of 30 seconds.")
                            .font(.footnote)
//                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    HStack(alignment: .top, spacing: 20) {
                        Image(systemName: "chart.xyaxis.line")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text("After the game concludes, your total and average scores(from previous attempts) will be shown.")
                            .lineLimit(nil)
                            .font(.footnote)
//                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(10.0)
                
                //            Text("You will be shown random square coordinates on the screen, you need to tap at the square to earn 1 point. Likewise the game goes for 30 seconds. At the end, the total score will be shown along with the average score which is calculated based on your previous scores. ")
                //                .font(.footnote)
                
//                Divider()
                
                Toggle("Don't show this again", isOn: $showIntro)
                    .font(.footnote)
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
            .padding(25)
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
                        .frame(width: 15, height: 15)
                        .foregroundColor(.red)
                }
                .padding([.top, .trailing], 10),
                alignment: .topTrailing
            )
        } // ZStack
    }
}

//#Preview {
//    CoordinatesIntroPopup()
//}
