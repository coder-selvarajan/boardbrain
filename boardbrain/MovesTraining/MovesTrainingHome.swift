//
//  MovesTrainingHome.swift
//  boardbrain
//
//  Created by Selvarajan on 19/04/24.
//

import SwiftUI

struct MovesTrainingHome: View {
    @ObservedObject var movesScoreViewModel = ScoreViewModel(type: TrainingType.Moves)
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showCoordinates = true
    @State private var whiteSide = true
    @State private var highlightPossibleMoves = true
    
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
    
    @State var currentPiece: ChessPiece?
    @State var possibleMoves: [Position]?
    
    @State var gameState: GameState?
    
    let timerInterval = 0.1
    let totalTime = 30.0
    
    private func startProgress() {
        progress = 0.0
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.progress += Float(timerInterval / totalTime)
            if self.progress >= 1.0 {
                timer.invalidate()
                
                //update the scores and persist
                movesScoreViewModel.updateScore(for: whiteSide ? .white : .black,
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
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                    .padding(0)
                Text("Back")
                    .foregroundColor(.blue)
                    .font(.system(size: 17))
            }
            .padding(.horizontal, 0)
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
            
            MovesBoardView(showCoordinates: $showCoordinates,
                           highlightPossibleMoves: $highlightPossibleMoves,
                           gameState: $gameState,
                           pieceMovedTo: { position in
                
                let isCorrectAnswer: Bool = (position == gameState!.targetPosition)
                if isCorrectAnswer {
                    score += 1
                }
                questionList.append(GameIteration(question: currentCoordinate,
                                                  answer: isCorrectAnswer))
                
                // trigger the next question
                gameState = GameState.nextState()
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
                    Text("Tap this square on the board: ")
                        .font(.footnote)
                    Text(currentCoordinate)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                } else {
                    if (movesScoreViewModel.scoreModel.totalPlayBlack > 0 || movesScoreViewModel.scoreModel.totalPlayWhite > 0) {
                        Text(String(format: "Last score (%@): %d/%d",
                                    movesScoreViewModel.scoreModel.lastScoreAs == .white ? "w" : "b",
                                    movesScoreViewModel.scoreModel.lastScore.correctAttempts,
                                    movesScoreViewModel.scoreModel.lastScore.totalAttempts))
                        .font(.footnote)
                        Text(String(format: "Average score as white: %.2f", movesScoreViewModel.scoreModel.avgScoreWhite))
                            .font(.footnote)
                        Text(String(format: "Average score as black: %.2f", movesScoreViewModel.scoreModel.avgScoreBlack))
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
                        gameState = GameState.nextState()
                        currentCoordinate = gameState!.question
                        
                        startProgress()
                    } label: {
                        Text("Start Training")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .frame(height: 60)
                            .background(.green)
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
                        MovesPopupOptions(showCoordinates: $showCoordinates, whiteSide: $whiteSide, highlightPossibleMoves: $highlightPossibleMoves)
                            .presentationDetents([.medium])
                    })
                }
            }
            Spacer()
        } //scrollview
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.20))
        .navigationTitle("Moves training")
        .navigationBarBackButtonHidden(gameStarted)
        .navigationBarItems(leading: !gameStarted ? nil : backButton)
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
                    Text(String(format: "as White:  %.2f \nas Black:  %.2f ", movesScoreViewModel.scoreModel.avgScoreWhite, movesScoreViewModel.scoreModel.avgScoreBlack))
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                    Text("Best Score: ")
                        .foregroundColor(.gray)
                    Text("as White:  \(movesScoreViewModel.scoreModel.bestScoreWhite.correctAttempts) / \(movesScoreViewModel.scoreModel.bestScoreWhite.totalAttempts) \nas Black:  \(movesScoreViewModel.scoreModel.bestScoreBlack.correctAttempts) / \(movesScoreViewModel.scoreModel.bestScoreBlack.totalAttempts)")
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
                    // Action for the gear icon
                }) {
                    Image(systemName: "info.circle")
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
    var currentPiece: ChessPiece
    var initialPosition: Position
    var possibleMoves: [Position]
    var targetPosition: Position
    var question: String
    var gameEnded: Bool = false
    
    static func nextState() -> GameState {
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
        let question = "\(randomPiece.type.getShortCode())\(rank[targetPosition.column])\(8 - targetPosition.row)"
        
        return GameState(currentPiece: randomPiece,
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
