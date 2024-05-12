//
//  GameView.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI
import PopupView

struct CoordinateTrainingHome: View {
    @AppStorage("showGameIntro") private var showIntro = true
    @AppStorage("coordinatesShowPiece") private var showPiecesPosition = true
    @AppStorage("coordinatesShowRanks") private var showRanksandFiles = true
    @AppStorage("coordinatesShowCoordinates") private var showCoordinates = false
    @AppStorage("coordinatesWhiteSide")  private var whiteSide = true
    
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    
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
    
    @State private var coordinateShownTime: Date?
//    @State private var averageRespTime: TimeInterval = 0.0
    
    @State private var showIntroModal = false
    @State private var hideControlsinPopup = false
    
    
    let timerInterval = 0.1
    let totalTime = 3.0
    
    let resultsPaneHeight = UIScreen.main.bounds.size.height * 0.06
    let actionButtonHeight = UIScreen.main.bounds.size.height * 0.075
    
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
                scoreViewModel.updateScore(type: TrainingType.Coordinates,
                                           color: whiteSide ? .white : .black,
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
                    HStack(alignment: .center, spacing: 20) {
                        if questionList.count > 0 {
                            VStack(alignment: .leading) {
                                Text("Results, ")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                                    .padding(0)
                                Text("Resp time:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        ForEach(questionList, id: \.id) { item in
                            VStack(alignment: .center) {
                                Text(item.question)
                                    .id(item.question)
                                    .font(.headline)
                                    .foregroundColor(item.answer ? .green : .red)
                                Text(String(format: "%.2f", item.responseTime) + "s")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
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
            .frame(height: resultsPaneHeight)
            
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
                
                //response time calculation
                var responseTime: TimeInterval = 0.0
                if let shownTime = coordinateShownTime {
                    responseTime = Date().timeIntervalSince(shownTime)
                }
                
                let clickedCoordinate = getCoordinate(forIndex: value)
                if clickedCoordinate == currentCoordinate {
                    // point count increases
                    score += 1
                }
                
                questionList.append(GameIteration(question: currentCoordinate,
                                                  answer: (clickedCoordinate == currentCoordinate),
                                                  responseTime: responseTime))
                
                currentPlay += 1
                currentCoordinate = getRandomCoordinate()
                coordinateShownTime = Date()
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
                        .font(.body)
                    Text(currentCoordinate)
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                        .padding()
                } else {
                    if (scoreViewModel.coordinatesScoreModel.totalPlayBlack > 0 || scoreViewModel.coordinatesScoreModel.totalPlayWhite > 0) {
                        Text(String(format: "Last score (%@): %d/%d",
                                    scoreViewModel.coordinatesScoreModel.lastScoreAs == .white ? "W" : "B",
                                    scoreViewModel.coordinatesScoreModel.lastScore.correctAttempts,
                                    scoreViewModel.coordinatesScoreModel.lastScore.totalAttempts))
                        .font(.footnote)
                        Text(String(format: "Average score as White: %.2f", scoreViewModel.coordinatesScoreModel.avgScoreWhite))
                            .font(.footnote)
                        Text(String(format: "Average score as Black: %.2f", scoreViewModel.coordinatesScoreModel.avgScoreBlack))
                            .font(.footnote)
                    }
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
                        coordinateShownTime = Date()
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
                        .frame(height: actionButtonHeight)
                        .background(.blue)
                        .cornerRadius(10.0)
                    }
                    
                    Button {
                        showingOptionsPopup = true
                    } label: {
                        HStack {
                            Image(systemName: "checklist")
                                .font(.title2)
                                .foregroundColor(.black.opacity(0.9))
                        }
                        .padding(.horizontal, 15)
                        .frame(height: actionButtonHeight)
                        .background(.white.opacity(0.75))
                        .cornerRadius(10.0)
                    }
                    .popover(isPresented: $showingOptionsPopup, content: {
                        CoordinatesPopupOptions(showPiecesPosition: $showPiecesPosition,
                                                showRanksandFiles: $showRanksandFiles,
                                                whiteSide: $whiteSide)
                        .presentationDetents([.medium])
                    })
                }
            }
            Spacer()
        } //scrollview
        .onAppear {
            if showIntro {
                showIntroModal = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.20))
        //            .navigationTitle("Coordinates training")
        .navigationBarTitleDisplayMode(.inline)
        .popup(isPresented: $showIntroModal) {
            CoordinatesIntroPopup(showIntroModal: $showIntroModal, hideControls: $hideControlsinPopup) {
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
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
                
                Text("Score: \(score)/\(currentPlay)")
                    .font(.title)
                    .foregroundColor(.green)
                HStack {
                    Text("Avg Resp Time")
                        .font(.footnote)
                        .foregroundColor(.black)
                    Text("\(averageResponseTime(iterationList: questionList))")
                        .font(.title3)
                        .foregroundColor(.black)
                    Text("sec")
                        .font(.footnote)
                        .foregroundColor(.black)
                }.padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Average Score: ")
                        .foregroundColor(.gray)
                    Text(String(format: "as White:  %.2f \nas Black:  %.2f ", scoreViewModel.coordinatesScoreModel.avgScoreWhite, scoreViewModel.coordinatesScoreModel.avgScoreBlack))
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                    Text("Best Score: ")
                        .foregroundColor(.gray)
                    Text("as White:  \(scoreViewModel.coordinatesScoreModel.bestScoreWhite.correctAttempts) / \(scoreViewModel.coordinatesScoreModel.bestScoreWhite.totalAttempts) \nas Black:  \(scoreViewModel.coordinatesScoreModel.bestScoreBlack.correctAttempts) / \(scoreViewModel.coordinatesScoreModel.bestScoreBlack.totalAttempts)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.25))
                .cornerRadius(15)
                .padding(.bottom)
                
                ShareScoreButton(trainingType: TrainingType.Coordinates,
                                 responseTime: averageResponseTime(iterationList: questionList),
                                 scoreModel: scoreViewModel.coordinatesScoreModel)

            }
            .padding(25)
            .background(.white)
            .cornerRadius(15)
            .frame(width: 250)
            .overlay(
                CloseButton() {
                    gameEnded = false
                }, alignment: .topTrailing
            )
            
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
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "square.grid.2x2")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Coordinates Training").font(.body)
                        .padding(.horizontal, 5)
                }
            } //ToolbarItem
            
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
        }
    }
}

#Preview {
    CoordinateTrainingHome()
}
