//
//  GameView.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI
import PopupView

struct CoordinateTrainingView: View {
    @ObservedObject var scoreViewModel = ScoreViewModel()
    
    @State private var showPiecesPosition = true
    @State private var showRanksandFiles = true
    @State private var showCoordinates = false
    @State private var whiteSide = true
    @State private var selectedColor = "White"
    @State private var targetIndex: Int = -1
    
    private let columns = 8
    
    @State var currentCoordinate: String = ""
    @State var score: Int = 0
    @State var gameStarted: Bool = false
    @State var gameEnded: Bool = false
    @State var currentPlay: Int = 0
    @State private var progress: Float = 0.0
    @State private var showingOptionsPopup = false
    @State var questionList: [GameIteration] = []
    
    let timerInterval = 0.1
    let totalTime = 30.0
    
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
    
    func getRandomCoordinate() -> String {
        let rndIndex = Int.random(in: 0..<64)
        targetIndex = rndIndex
        return getCoordinate(forIndex: rndIndex)
    }
    
    private func startProgress() {
        progress = 0.0
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.progress += Float(timerInterval / totalTime)
            if self.progress >= 1.0 {
                timer.invalidate()
                
                //update the scores and persist
                scoreViewModel.updateScore(for: whiteSide ? .white : .black, 
                                           score: Score(correctAttempts: score, totalAttempts: currentPlay))
                
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
                        guard !questionList.isEmpty else { return }
                        withAnimation {
                            value.scrollTo(questionList.last?.question,
                                           anchor: .trailing)
                        }
                    }
                }
                .frame(height: 50)
                
                BoardView(showPiecesPosition: $showPiecesPosition,
                          showRanksandFiles: $showRanksandFiles,
                          showCoordinates: $showCoordinates,
                          whiteSide: $whiteSide,
                          targetIndex: $targetIndex,
                          gameStarted: $gameStarted,
                          squareClicked: { value in
                    // game logic, validating clicked squares
                    if gameEnded || !gameStarted {
                        return
                    }
                    
                    
                    
                    let clickedCoordinate = getCoordinate(forIndex: value)
                    if clickedCoordinate == currentCoordinate {
                        // point count increases
                        score += 1
                    }
                    
                    questionList.append(GameIteration(question: currentCoordinate,
                                                  answer: (clickedCoordinate == currentCoordinate)))
                    
                    currentPlay += 1
                    currentCoordinate = getRandomCoordinate()
                })
                
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .padding(.bottom, 10)
                    .padding(.top, -5)
                
                Spacer()
                VStack(alignment: .center, spacing: 5) {
                    if gameStarted {
                        Text("Tap this square on the board: ")
                            .font(.footnote)
                        Text(currentCoordinate)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        Text(String(format: "Last score (%@): %d/%d",
                                    scoreViewModel.scoreModel.lastScoreAs == .white ? "w" : "b",
                                    scoreViewModel.scoreModel.lastScore.correctAttempts,
                                    scoreViewModel.scoreModel.lastScore.totalAttempts))
                            .font(.subheadline)
                            .padding(.bottom, 10)
                        Text(String(format: "Average score as white: %.2f", scoreViewModel.scoreModel.avgScoreWhite))
                            .font(.footnote)
                        Text(String(format: "Average score as black: %.2f", scoreViewModel.scoreModel.avgScoreBlack))
                            .font(.footnote)
                    }
                }
                
                Spacer()
                HStack(spacing: 15) {
                    if !gameStarted {
                        Button {
                            gameStarted = true
                            gameEnded = false
                            
                            questionList.removeAll()
                            
                            currentCoordinate = getRandomCoordinate()
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
                        
                        
                        Button {
                            showingOptionsPopup = true
                        } label: {
                            HStack {
                                Image(systemName: "gearshape")
                                    .font(.title2)
                                    .foregroundColor(.black.opacity(0.9))
                            }
                            .padding(.horizontal, 15)
                            .frame(height: 60)
                            .background(.white.opacity(0.75))
                            .cornerRadius(10.0)
                        }
                        .popover(isPresented: $showingOptionsPopup, content: {
                            PopupBoardOptions(showPiecesPosition: $showPiecesPosition,
                                              showRanksandFiles: $showRanksandFiles,
                                              whiteSide: $whiteSide)
                            .presentationDetents([.medium])
                        })
                    }
                }
                Spacer()
            } //scrollview
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.20))
            .navigationTitle("Coordinates training")
            .navigationBarTitleDisplayMode(.inline)
            .popup(isPresented: $gameEnded) {
                VStack {
                    Text("Game over!")
                        .foregroundColor(.black)
                        .padding(.bottom, 5)
                    
                    Text("Score: \(score)/\(currentPlay)")
                        .font(.title)
                        .foregroundColor(.green)
                    
                    VStack(alignment: .leading) {
                        Text("Average Score: ")
                            .foregroundColor(.gray)
                        Text(String(format: "as White:  %.2f \nas Black:  %.2f ", scoreViewModel.scoreModel.avgScoreWhite, scoreViewModel.scoreModel.avgScoreBlack))
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.bottom)
                        
                        Text("Best Score: ")
                            .foregroundColor(.gray)
                        Text("as White:  \(scoreViewModel.scoreModel.bestScoreWhite.correctAttempts) / \(scoreViewModel.scoreModel.bestScoreWhite.totalAttempts) \nas Black:  \(scoreViewModel.scoreModel.bestScoreBlack.correctAttempts) / \(scoreViewModel.scoreModel.bestScoreBlack.totalAttempts)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.bottom)
                        
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.25))
                    .cornerRadius(15)
                    .padding(.bottom)
                    
                    
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
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Button("Introduction", action: {})
//                        Button("Game: Coordinates", action: {})
//                        Button("Game: Moves", action: {})
//                        Button("Game: Light/Dark", action: {})
//                    } label: {
//                        Image(systemName: "line.horizontal.3")
//                            .foregroundColor(.white)
//                    }
//                }
                
                // Gear icon on the right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for the gear icon
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                    }
                }
            }
    }
}

#Preview {
    CoordinateTrainingView()
}
