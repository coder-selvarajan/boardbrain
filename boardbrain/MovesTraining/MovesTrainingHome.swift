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
    
    @State var currentPiece: ChessPiece?
    @State var possibleMoves: [Position]?
    
    @State var gameState: GameState?
    
    @State private var showIntroModal = false
    @State private var hideControlsinPopup = false
    
    let resultsPaneHeight = UIScreen.main.bounds.size.height * 0.065
    let actionButtonHeight = UIScreen.main.bounds.size.height * 0.075
    
    let timerInterval = 0.1
    let totalTime = 30.0
    
    
    private func startProgress() {
        progress = 0.0
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.progress += Double(timerInterval / totalTime)
            if self.progress >= 1.0 {
                timer.invalidate()
                
                //update the scores and persist
                scoreViewModel.updateScore(type: .Moves,
                                                color: whiteSide ? .white : .black,
                                                score: Score(correctAttempts: score, totalAttempts: currentPlay))
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
                    HStack(alignment: .center, spacing: 15) {
                        if questionList.count > 0 {
                            Text("Results: ")
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
            .frame(height: resultsPaneHeight)
            
            MovesBoardView(showCoordinates: $showCoordinates,
                           highlightPossibleMoves: $highlightPossibleMoves,
                           whiteSide: $whiteSide,
                           gameState: $gameState,
                           pieceMovedTo: { position in
                
                let isCorrectAnswer: Bool = (position == gameState!.targetPosition)
                if isCorrectAnswer {
                    score += 1
                }
                questionList.append(GameIteration(question: currentCoordinate,
                                                  answer: isCorrectAnswer))
                
                // trigger the next question
                gameState = GameState.nextState(whiteSide: whiteSide)
                currentCoordinate = gameState!.question
                
                currentPlay += 1
                
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
                    if (scoreViewModel.movesScoreModel.totalPlayBlack > 0 || scoreViewModel.movesScoreModel.totalPlayWhite > 0) {
                        Text(String(format: "Last score (%@): %d/%d",
                                    scoreViewModel.movesScoreModel.lastScoreAs == .white ? "w" : "b",
                                    scoreViewModel.movesScoreModel.lastScore.correctAttempts,
                                    scoreViewModel.movesScoreModel.lastScore.totalAttempts))
                        .font(.footnote)
                        Text(String(format: "Average score as white: %.2f", scoreViewModel.movesScoreModel.avgScoreWhite))
                            .font(.footnote)
                        Text(String(format: "Average score as black: %.2f", scoreViewModel.movesScoreModel.avgScoreBlack))
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
                        
                        //                        currentCoordinate = getRandomCoordinate()
                        currentPlay = 0
                        score = 0
                        
                        //pick random square and a piece
                        gameState = GameState.nextState(whiteSide: whiteSide)
                        currentCoordinate = gameState!.question
                        
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
                    Text(String(format: "as White:  %.2f \nas Black:  %.2f ", scoreViewModel.movesScoreModel.avgScoreWhite, scoreViewModel.movesScoreModel.avgScoreBlack))
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                    Text("Best Score: ")
                        .foregroundColor(.gray)
                    Text("as White:  \(scoreViewModel.movesScoreModel.bestScoreWhite.correctAttempts) / \(scoreViewModel.movesScoreModel.bestScoreWhite.totalAttempts) \nas Black:  \(scoreViewModel.movesScoreModel.bestScoreBlack.correctAttempts) / \(scoreViewModel.movesScoreModel.bestScoreBlack.totalAttempts)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(.gray.opacity(0.25))
                .cornerRadius(15)
                .padding(.bottom)
                
                ShareScoreButton(trainingType: TrainingType.Moves,
                                 responseTime: "0.5",
                                 scoreModel: scoreViewModel.movesScoreModel)
                
//                Button {
//                    gameEnded = false
//                } label: {
//                    HStack {
//                        Spacer()
//                        Text("Close")
//                            .font(.headline)
//                            .foregroundColor(.black)
//                            .padding(.vertical, 10)
//                        Spacer()
//                    }
//                }
//                .background(.cyan.opacity(0.80))
//                .frame(maxWidth: .infinity)
//                .cornerRadius(10)
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
