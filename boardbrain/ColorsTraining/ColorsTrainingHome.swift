//
//  ColorsTrainingHome.swift
//  boardbrain
//
//  Created by Selvarajan on 14/04/24.
//

import SwiftUI
import PopupView

struct ColorsTrainingHome: View {
    @ObservedObject var colorsScoreViewModel = ScoreViewModel(type: TrainingType.Colors)
    @EnvironmentObject var themeManager: ThemeManager
    
    @AppStorage("colorsShowCoordinates") private var showCoordinates = true
    @AppStorage("colorsWhiteSide") private var whiteSide = true
    
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
    
    @State private var showIntroModal = false
    @State private var hideControlsinPopup = false
    
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
                colorsScoreViewModel.updateScore(for: whiteSide ? .white : .black,
                                                 score: Score(correctAttempts: score,
                                                        totalAttempts: currentPlay))
                
                gameEnded = true
                gameStarted = false
            }
        }
    }
    
    var body: some View {
        
        VStack {
            ScrollViewReader { value in
                ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 15) {
                        if questionList.count > 0 {
                            Text("Result: ")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.9))
                                .padding(0)
                        }
                        ForEach(questionList, id: \.id) { item in
                            Text(item.question)
                                .id(item.question)
                                .font(.body)
                                .foregroundColor(item.answer ? .green : .red)
                        }
                    }
                    .padding(.trailing)
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
            
            ColorsBoardView(showCoordinates: $showCoordinates,
                            whiteSide: $whiteSide,
                            highlightIndex: $targetIndex,
                            gameEnded: $gameEnded,
                            gameStarted: $gameStarted,
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
                            .foregroundColor(themeManager.boardColors.0)
                            .cornerRadius(10.0)
                            .padding(.vertical)
                            .onTapGesture {
                                answerQuestion(with: SquareColor.light)
                            }
                        
                        Rectangle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(themeManager.boardColors.1)
                            .cornerRadius(10.0)
                            .padding(.vertical)
                            .onTapGesture {
                                answerQuestion(with: SquareColor.dark)
                            }
                    }
                } else if (colorsScoreViewModel.scoreModel.totalPlayBlack > 0 || colorsScoreViewModel.scoreModel.totalPlayWhite > 0) {
                        Text(String(format: "Last score (%@): %d/%d",
                                    colorsScoreViewModel.scoreModel.lastScoreAs == .white ? "W" : "B",
                                    colorsScoreViewModel.scoreModel.lastScore.correctAttempts,
                                    colorsScoreViewModel.scoreModel.lastScore.totalAttempts))
                        .font(.footnote)
                        Text(String(format: "Average score as white: %.2f", colorsScoreViewModel.scoreModel.avgScoreWhite))
                            .font(.footnote)
                        Text(String(format: "Average score as black: %.2f", colorsScoreViewModel.scoreModel.avgScoreBlack))
                            .font(.footnote)
                }
            }
//            .padding(.top, -40)
            
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
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "play.circle")
                                .font(.title3)
                                .foregroundColor(.black.opacity(0.75))
                        
                            Text("Start Training")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 60)
                        .background(.yellow)
                        .cornerRadius(10.0)
                    }
                    
                    Button {
                        showingOptionsPopup = true
                    } label: {
                        HStack {
                            Image(systemName: "checklist") //gearshape.fill")
                                .font(.title2)
                                .foregroundColor(.black.opacity(0.9))
                        }
                        .padding(.horizontal, 15)
                        .frame(height: 60)
                        .background(.white.opacity(0.95))
                        .cornerRadius(10.0)
                    }
                    .popover(isPresented: $showingOptionsPopup, content: {
                        ColorsPopupOptions(showCoordinates: $showCoordinates, 
                                           whiteSide: $whiteSide)
                            .presentationDetents([.medium])
                    })
                }
            }
            Spacer()
        } //VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.20))
        .navigationTitle("Colors training")
        .navigationBarTitleDisplayMode(.inline)
        .popup(isPresented: $showIntroModal) {
            ColorsIntroPopup(showIntroModal: $showIntroModal, hideControls: $hideControlsinPopup) {
                //
            }
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring())
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.5))
                .autohideIn(50)
        }
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
                    Text(String(format: "as White:  %.2f \nas Black:  %.2f ", colorsScoreViewModel.scoreModel.avgScoreWhite, colorsScoreViewModel.scoreModel.avgScoreBlack))
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                    Text("Best Score: ")
                        .foregroundColor(.gray)
                    Text("as White:  \(colorsScoreViewModel.scoreModel.bestScoreWhite.correctAttempts) / \(colorsScoreViewModel.scoreModel.bestScoreWhite.totalAttempts) \nas Black:  \(colorsScoreViewModel.scoreModel.bestScoreBlack.correctAttempts) / \(colorsScoreViewModel.scoreModel.bestScoreBlack.totalAttempts)")
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
            // Gear icon on the right
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    hideControlsinPopup = true
                    showIntroModal = true
                }) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.white)
                }
            }
        } //toolbar
    } //body
}

#Preview {
    ColorsTrainingHome()
}
