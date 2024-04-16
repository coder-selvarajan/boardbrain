//
//  MovesTrainingView.swift
//  boardbrain
//
//  Created by Selvarajan on 14/04/24.
//

import SwiftUI
import PopupView

struct ColorsTrainingView: View {
    
    @State private var showCoordinates = false
    @State private var whiteSide = true
    @State private var selectedColor = "White"
    @State private var targetIndex: Int = -1
    
    private let columns = 8
    
    @State var currentCoordinate: String = ""
    @State var currentSquareColor: SquareColor = .dark
    
    @State var score: Int = 0
    @State var gameStarted: Bool = false
    @State var gameEnded: Bool = false
    @State var currentPlay: Int = 0
    @State private var progress: Float = 0.0
    @State private var showingOptionsPopup = false
    @State var questionList: [GameIteration] = []
    
    let timerInterval = 0.1
    let totalTime = 30.0
    let darkSquareIndexes = [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23, 24, 26, 28, 30, 33, 35, 37, 39, 40, 42, 44, 46, 49, 51, 53, 55, 56, 58, 60, 62]
    
    private func getCoordinate(forIndex index: Int) -> String {
        let filesWhite = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let filesBlack = ["h", "g", "f", "e", "d", "c", "b", "a"]
        
        var rank = 0
        var file = ""
        
        if whiteSide {
            rank = 8 - index / columns
            file = filesWhite[index % columns]
        }
        else {
            rank = (8 + index) / columns
            file = filesBlack[index % columns]
        }
        
        let square = Square(rank: rank, file: file, index: index)
        return square.getCoordinate()
    }
    
    func getRandomCoordinate() -> (Int, String) {
        let rndIndex = Int.random(in: 0..<64)
        targetIndex = rndIndex
        return (rndIndex, getCoordinate(forIndex: rndIndex))
    }
    
    func answerQuestion(with answerColor: SquareColor) {
        if answerColor == currentSquareColor {
            score += 1
        }
        questionList.append(GameIteration(question: currentCoordinate, answer: answerColor == currentSquareColor))
        
        let tupleRandomCoordinates = getRandomCoordinate()
        let rndIndex = tupleRandomCoordinates.0
        let rndLabel = tupleRandomCoordinates.1
        targetIndex = rndIndex
        currentCoordinate = rndLabel
        currentSquareColor = darkSquareIndexes.contains(rndIndex) ? .dark : .light
        
        currentPlay += 1
    }
    
    private func startProgress() {
        progress = 0.0
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.progress += Float(timerInterval / totalTime)
            if self.progress >= 1.0 {
                timer.invalidate()
                
                //update the scores and persist
                //                scoreViewModel.updateScore(for: whiteSide ? .white : .black,
                //                                           score: Score(correctAttempts: score, totalAttempts: currentPlay))
                
                gameEnded = true
                gameStarted = false
            }
        }
    }
    
    var body: some View {
        
        VStack {
            ScrollViewReader { value in
                ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(questionList, id: \.id) { item in
                            Text(item.question)
                                .id(item.question)
                                .font(.body)
                                .foregroundColor(item.answer ? .green : .red)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                .onChange(of: questionList) {
                    if questionList.count < 1 {
                        return
                    }
                    withAnimation {
                        value.scrollTo(questionList[questionList.count - 1],
                                       anchor: .trailing)
                    }
                }
            }
            .frame(height: 50)
            
            SimpleBoardView(showCoordinates: .constant(true), 
                            whiteSide: .constant(true),
                            showSquareColors: .constant(false),
                            showSquareBorders: .constant(true),
                            highlightIndex: $targetIndex,
                            gameEnded: $gameEnded, 
                            squareClicked: nil)
            
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                .scaleEffect(x: 1, y: 3, anchor: .center)
                .padding(.bottom, 20)
                .padding(.top, -5)
            
            Spacer()
            VStack(alignment: .center, spacing: 5) {
                if gameStarted {
                    Text("Choose the right color")
                        .font(.body)
                    Text("for the above highlighted square ")
                        .font(.footnote)
                    
                    HStack(spacing: 40) {
                        
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(hex: "#F0D9B5"))
                            .cornerRadius(10.0)
                            .padding(.vertical)
                            .onTapGesture {
                                answerQuestion(with: SquareColor.light)
                            }
                        
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(hex: "#C58863"))
                            .cornerRadius(10.0)
                            .padding(.vertical)
                            .onTapGesture {
                                answerQuestion(with: SquareColor.dark)
                            }
                    }
                    
                    
                } else {
                    //
                }
            }
            
            Spacer()
            HStack(spacing: 15) {
                if !gameStarted {
                    Button {
                        gameStarted = true
                        gameEnded = false
                        
                        questionList.removeAll()
                        
                        let tupleRandomCoordinates = getRandomCoordinate()
                        let rndIndex = tupleRandomCoordinates.0
                        let rndLabel = tupleRandomCoordinates.1
                        targetIndex = rndIndex
                        currentCoordinate = rndLabel
                        currentSquareColor = darkSquareIndexes.contains(rndIndex) ? .dark : .light
                        
                        currentPlay = 0
                        score = 0
                        
                        startProgress()
                    } label: {
                        Text("Start Training")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .frame(height: 60)
                            .background(.blue)
                            .cornerRadius(10.0)
                    }
                    
                    
//                    Button {
//                        showingOptionsPopup = true
//                    } label: {
//                        HStack {
//                            Image(systemName: "gearshape")
//                                .font(.title2)
//                                .foregroundColor(.black.opacity(0.9))
//                        }
//                        .padding(.horizontal, 15)
//                        .frame(height: 60)
//                        .background(.white.opacity(0.75))
//                        .cornerRadius(10.0)
//                    }
                    //
                }
            }
            Spacer()
        } //VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.20))
        .navigationTitle("Colors training")
        .navigationBarTitleDisplayMode(.inline)
        .popup(isPresented: $gameEnded) {
            VStack {
                Text("Game over!")
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
                
                Text("Score: \(score)/\(currentPlay)")
                    .font(.title)
                    .foregroundColor(.green)
                
                Button {
                    gameEnded = false
                } label: {
                    HStack {
                        Spacer()
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                        Spacer()
                    }
                }
                .background(.cyan.opacity(0.80))
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
            }
            .padding(25)
            .background(.white)
            .cornerRadius(15)
            .frame(width: 250)
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(false)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
                .autohideIn(100)
        }
        .toolbar {
            // Hamburger menu icon on the left
//            ToolbarItem(placement: .navigationBarLeading) {
//                Menu {
//                    Button("Introduction", action: {})
//                    Button("Game: Coordinates", action: {})
//                    Button("Game: Moves", action: {})
//                    Button("Game: Light/Dark", action: {})
//                } label: {
//                    Image(systemName: "line.horizontal.3")
//                        .foregroundColor(.white)
//                }
//            }
            
            // Gear icon on the right
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action for the gear icon
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                }
            }
        } //toolbar
    } //body
}

#Preview {
    ColorsTrainingView()
}
