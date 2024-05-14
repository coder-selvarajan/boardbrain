//
//  MovesTrainingHome.swift
//  boardbrain
//
//  Created by Selvarajan on 19/04/24.
//

import SwiftUI

struct MovesTrainingHome: View {
    @EnvironmentObject var scoreViewModel : ScoreViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("showGameIntro") private var showIntro = true
    @AppStorage("movesShowCoordinates") private var showCoordinates = true
    @AppStorage("movesWhiteSide") private var whiteSide = true
    @AppStorage("movesHighlightMoves")  private var highlightPossibleMoves = true
    
    @State private var selectedColor = "White"
    @State private var targetIndex: Int = -1
    
    private let columns = 8
    
    @State var currentCoordinate: String = ""
    @State var score: Int = 0
    @State var gameStarted: Bool = false
    @State var gameEnded: Bool = false
    @State var currentPlay: Int = 0
    @State private var progress = 0.0
    @State private var showingOptionsPopup = false
    @State var questionList: [GameIteration] = []
    @State private var moveCoordinateShownTime: Date? // to calculate response time
    
    @State var currentPiece: ChessPiece?
    @State var possibleMoves: [Position]?
    
    @State var gameState: GameState?
    
    @State private var showIntroModal = false
    @State private var hideControlsinPopup = false
    
    @State private var timer: Timer?
    
    let resultsPaneHeight = UIScreen.main.bounds.size.height * 0.065
    let actionButtonHeight = UIScreen.main.bounds.size.height * 0.075
    
    let timerInterval = 0.1
    let totalTime = 30.0
    var avgResponseTime: String {
        return averageResponseTime(iterationList: questionList)
    }
    
    private func startProgress() {
        progress = 0.0
        // store the timer here, so that we can invalidate it when the user navigates back to another view.
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.progress += Double(timerInterval / totalTime)
            if self.progress >= 1.0 {
                timer.invalidate()
                
                //update the scores and persist
                scoreViewModel.updateScore(type: .Moves,
                                                color: whiteSide ? .white : .black,
                                                score: Score(correctAttempts: score, 
                                                             totalAttempts: currentPlay,
                                                             avgResponseTime: avgResponseTime))
                if gameState != nil {
                    gameState!.gameEnded = true
                }
                gameEnded = true
                gameStarted = false
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 3) {
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
//                    .foregroundColor(.blue)
//                    .padding(0)
                Text("Back")
                    .foregroundColor(.blue)
//                    .font(.system(size: 17))
            }
            .padding(.horizontal, 0)
        }
    }
    
    var body: some View {
        VStack {
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
            
            MovesBoardView(showCoordinates: $showCoordinates,
                           highlightPossibleMoves: $highlightPossibleMoves,
                           whiteSide: $whiteSide,
                           gameState: $gameState,
                           pieceMovedTo: { position in
                
                //response time calculation
                var responseTime: TimeInterval = 0.0
                if let shownTime = moveCoordinateShownTime {
                    responseTime = Date().timeIntervalSince(shownTime)
                }
                
                let isCorrectAnswer: Bool = (position == gameState!.targetPosition)
                if isCorrectAnswer {
                    score += 1
                }
                questionList.append(GameIteration(question: currentCoordinate,
                                                  answer: isCorrectAnswer,
                                                  responseTime: responseTime))
                
                // trigger the next question
                gameState = GameState.nextState(whiteSide: whiteSide)
                currentCoordinate = gameState!.question
                
                currentPlay += 1
                moveCoordinateShownTime = Date()
            })
            .frame(height: UIScreen.main.bounds.size.width)
            
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                .scaleEffect(x: 1, y: 3, anchor: .center)
                .padding(.bottom, 10)
                .padding(.top, -5)
            
            Spacer()
            VStack(alignment: .center, spacing: 5) {
                if gameStarted {
                    Text("Drag the piece to the specified square.")
                        .font(.body)
                    Text(currentCoordinate)
                        .font(.system(size: 40))
                        .foregroundColor(.yellow)
                        .padding()
                } else {
                    // Show last score and average scores
                    DisplayScoreView(scoreModel: scoreViewModel.movesScoreModel)
                }
            }
            
            Spacer()
            HStack(spacing: 15) {
                if !gameStarted {
                    Button {
                        gameStarted = true
                        gameEnded = false
                        
                        questionList.removeAll()
                        
                        currentPlay = 0
                        score = 0
                        
                        //pick random square and a piece
                        gameState = GameState.nextState(whiteSide: whiteSide)
                        currentCoordinate = gameState!.question
                        moveCoordinateShownTime = Date()
                        
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
                        .background(.green)
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
                        MovesPopupOptions(showCoordinates: $showCoordinates, whiteSide: $whiteSide, highlightPossibleMoves: $highlightPossibleMoves)
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
        .onDisappear() {
            timer?.invalidate()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.20))
//        .navigationTitle("Moves training")
        .navigationBarBackButtonHidden(gameStarted)
        .navigationBarItems(leading: !gameStarted ? nil : backButton)
        .navigationBarTitleDisplayMode(.inline)
//        .navigationPopGestureDisabled(gameStarted)
        .popup(isPresented: $showIntroModal) {
            MovesIntroPopup(showIntroModal: $showIntroModal, hideControls: $hideControlsinPopup) {
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
            ScorePopup(trainingType: TrainingType.Moves,
                       correctAttempts: score,
                       totalAttempts: currentPlay,
                       questionList: questionList,
                       scoreModel: scoreViewModel.movesScoreModel,
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
                    Image(systemName: "crown")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Moves Training").font(.body)
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

//#Preview {
//    MovesTrainingHome()
//        .colorScheme(ColorScheme.dark)
//}

struct GameState {
    var whiteSide: Bool
    var currentPiece: ChessPiece
    var initialPosition: Position
    var possibleMoves: [Position]
    var targetPosition: Position
    var question: String
    var gameEnded: Bool = false
    
    static func nextState(whiteSide: Bool) -> GameState {
        let rank = ["a","b","c","d","e","f","g","h"]
        
        // excluding pawn, as it has only one move forward
        let pieceTypes = ChessPieceType.allCases.filter { $0 != .pawn }
        let randomPieceType = pieceTypes.randomElement()!
        let randomPosition = Position(row: Int.random(in: 0..<8), column: Int.random(in: 0..<8))
        let randomPiece = ChessPiece(type: randomPieceType, row: randomPosition.row, column: randomPosition.column)
        
        //get possible moves for the piece at the position
        let allowedMoves = getMoves(for: randomPieceType, from: randomPosition)
        //pick one target position
        let targetPosition = allowedMoves.randomElement()!
        
        print("targetPosition: ", targetPosition)
        // form the question
        var question = ""
        if whiteSide {
            question = "\(randomPiece.type.getShortCode())\(rank[targetPosition.column])\(8 - targetPosition.row)"
        }
        else {
            question =  "\(randomPiece.type.getShortCode())\(rank.reversed()[targetPosition.column])\(targetPosition.row + 1)"
        }
        
        return GameState(whiteSide: whiteSide,
                         currentPiece: randomPiece,
                         initialPosition: randomPosition,
                         possibleMoves: allowedMoves,
                         targetPosition: targetPosition,
                         question: question)
    }
    
    static func getMoves(for type: ChessPieceType, from position: Position) -> [Position] {
        switch type {
        case .rook:
            return Position.straightMoves(from: position)
        case .bishop:
            return Position.diagonalMoves(from: position)
        case .knight:
            return Position.knightMoves(from: position)
        case .queen:
            return Position.straightMoves(from: position) + Position.diagonalMoves(from: position)
        case .king:
            return Position.kingMoves(from: position)
        default:
            return []
        }
    }
    
}
