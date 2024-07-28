//
//  ColorsTrainingHome.swift
//  boardbrain
//
//  Created by Selvarajan on 14/04/24.
//

import SwiftUI
import PopupView
import TelemetryDeck

struct ColorsTrainingHome: View {
    @EnvironmentObject var scoreViewModel : ScoreViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @AppStorage("colorsShowCoordinates") private var showCoordinates = true
    @AppStorage("colorsWhiteSide") private var whiteSide = true
    @AppStorage("hapticFeedback") private var hapticFeedbackEnabled = true
    
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
    @State private var colorCoordinateShownTime: Date? // to calculate response time
    
    @State private var showIntroModal = false
    @State private var hideControlsinPopup = false
    
    @State private var timer: Timer?
    
    let resultsPaneHeight = UIScreen.main.bounds.size.height * 0.065
    let actionButtonHeight = UIScreen.main.bounds.size.height * 0.075
    
    let timerInterval = 0.1
    
    let darkSquareIndexes = [1, 3, 5, 7, 8, 10, 12, 14, 17, 19, 21, 23, 24, 26, 28, 30, 33, 35, 37, 39, 40, 42, 44, 46, 49, 51, 53, 55, 56, 58, 60, 62]
    var avgResponseTime: String {
        return averageResponseTime(iterationList: questionList)
    }
    
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
        // generate a mild haptic feedback
        if hapticFeedbackEnabled {
            performSoftHapticFeedback()
        }
        
        //response time calculation
        var responseTime: TimeInterval = 0.0
        if let shownTime = colorCoordinateShownTime {
            responseTime = Date().timeIntervalSince(shownTime)
        }
        
        if answerColor == currentSquareColor {
            score += 1
        }
        questionList.append(GameIteration(question: currentCoordinate, 
                                          answer: answerColor == currentSquareColor,
                                          responseTime: responseTime))
        
        let tupleRandomCoordinates = getRandomCoordinate()
        let rndIndex = tupleRandomCoordinates.0
        let rndLabel = tupleRandomCoordinates.1
        targetIndex = rndIndex
        currentCoordinate = rndLabel
        currentSquareColor = darkSquareIndexes.contains(rndIndex) ? .dark : .light
        
        currentPlay += 1
        colorCoordinateShownTime = Date()
    }
    
    private func startProgress() {
        progress = 0.0
        // store the timer here, so that we can invalidate it when the user navigates back to another view.
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.progress += Float(timerInterval / GAME_TIMER_SECONDS)
            if self.progress >= 1.0 {
                timer.invalidate()
                
                //update the scores and persist
                scoreViewModel.updateScore(type: TrainingType.Colors,
                                                 color: whiteSide ? .white : .black,
                                                 score: Score(correctAttempts: score,
                                                              totalAttempts: currentPlay,
                                                              avgResponseTime: avgResponseTime))
                
                gameEnded = true
                gameStarted = false
            }
        }
    }
    private var resultScrollView: some View {
        ScrollViewReader { value in
            ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 20) {
                    if questionList.count > 0 {
                        VStack(alignment: .leading) {
                            Text("Results & ")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.95))
                                .padding(0)
                            Text("Resp. time:")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.95))
                        }
                    }
                    
                    ForEach(questionList, id: \.id) { item in
                        VStack(alignment: .center) {
                            Text(item.question)
                                .id(item.id)
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
            .onChange(of: questionList) { _ in
                guard !questionList.isEmpty else { return }
                withAnimation {
                    value.scrollTo(questionList.last?.id,
                                   anchor: .trailing)
                }
            }
        }
        .frame(height: resultsPaneHeight)
    }
    
    var gameActionOptions: some View {
        VStack(alignment: .center, spacing: 5) {
            if gameStarted {
                Text("Choose the right color")
                    .font(.body)
                Text("for the highlighted square ")
                    .font(.footnote)
                
                HStack(spacing: 40) {
                    
                    Rectangle()
                        .frame(width: actionButtonHeight, height: actionButtonHeight)
                        .foregroundColor(themeManager.boardColors.0)
                        .cornerRadius(10.0)
                        .padding(.vertical)
                        .onTapGesture {
                            answerQuestion(with: SquareColor.light)
                        }
                    
                    Rectangle()
                        .frame(width: actionButtonHeight, height: actionButtonHeight)
                        .foregroundColor(themeManager.boardColors.1)
                        .cornerRadius(10.0)
                        .padding(.vertical)
                        .onTapGesture {
                            answerQuestion(with: SquareColor.dark)
                        }
                }
            } else {
                // Show last score and average scores
                DisplayScoreView(scoreModel: scoreViewModel.colorsScoreModel)
            }
        }
    }
    
    var actionButtons: some View {
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
                    colorCoordinateShownTime = Date()
                    
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
                    .frame(height: actionButtonHeight)
                    .background(.white.opacity(0.95))
                    .cornerRadius(10.0)
                }
                .popover(isPresented: $showingOptionsPopup, content: {
                    if #available(iOS 16.0, *) {
                        ColorsPopupOptions(showCoordinates: $showCoordinates,
                                           whiteSide: $whiteSide)
                        .presentationDetents([.medium])
                    } else {
                        // Fallback on earlier versions
                        ColorsPopupOptions(showCoordinates: $showCoordinates,
                                           whiteSide: $whiteSide)
                    }
                })
            }
        }
    }
    
    var body: some View {
        
        VStack {
            resultScrollView
            ColorsBoardView(showCoordinates: $showCoordinates,
                            whiteSide: $whiteSide,
                            highlightIndex: $targetIndex,
                            gameEnded: $gameEnded,
                            gameStarted: $gameStarted,
                            squareClicked: nil)
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                .scaleEffect(x: 1, y: 3, anchor: .center)
                .padding(.bottom, 20)
                .padding(.top, -5)
            
            Spacer()
            gameActionOptions
            Spacer()
            actionButtons
            Spacer()
        } //VStack
        .onAppear(){
            TelemetryDeck.signal(
                "Page Load",
                parameters: [
                    "app": "BoardBrain",
                    "event": "page load",
                    "identifier":"colors-training-home",
                    "viewName":"Colors Training Home View"
                ]
            )
        }
        .onDisappear() {
            timer?.invalidate()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.20))
//        .navigationTitle("Colors training")
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
            ScorePopup(trainingType: TrainingType.Colors,
                       correctAttempts: score,
                       totalAttempts: currentPlay,
                       questionList: questionList,
                       scoreModel: scoreViewModel.colorsScoreModel,
                       gameEnded: $gameEnded)
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
                    Image(systemName: "square.lefthalf.filled")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Colors Training").font(.body)
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
        } //toolbar
    } //body
}

#Preview {
    ColorsTrainingHome()
}
