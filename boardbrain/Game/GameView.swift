//
//  GameView.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI
import PopupView

struct PopupOverView: View {
    // Binding variables to pass state between views
    @Binding var showPiecesPosition: Bool
    @Binding var showRanksandFiles: Bool
    @Binding var whiteSide: Bool
    
    var body: some View {
        VStack {
            Text("Board Options")
                .font(.title2)
                .padding(.bottom)
            Divider()
            
            Toggle("Show Pieces", isOn: $showPiecesPosition)
                .font(.title2)
                .padding()
            Toggle("Show Coordinates", isOn: $showRanksandFiles)
                .font(.title2)
                .padding()
            
            HStack(alignment: .center) {
                Text("Color")
                    .font(.title2)
                    .padding(.leading)
                
                Spacer()
                
                HStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(whiteSide ? .green : .gray)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedCorner(radius: 5, corners: [.topLeft, .bottomLeft]))
                            .padding(0)
                        
                        
                        Image("king-w")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                whiteSide = !whiteSide
                            }
                    }.onTapGesture {
                        whiteSide = !whiteSide
                    }
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(!whiteSide ? .green : .gray)
                            .frame(width: 50, height:50)
                            .clipShape(RoundedCorner(radius: 5, corners: [.topRight, .bottomRight]))
                            .padding(0)
                        
                        Image("king-b")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                whiteSide = !whiteSide
                            }
                    }
                    .onTapGesture {
                        whiteSide = !whiteSide
                    }
                } // HStack
                .padding(.top)
                .padding(.trailing)
            } // HStack
            
            Spacer()
        }
        .padding()
    }
}

struct Iteration: Hashable {
    var question : String
    var answer : Bool
}

struct GameView: View {
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
    
    @State var questionList: [Iteration] = []
    
    @State var scoreModel: ScoreModel = ScoreModel(lastScore: Score(success: 11, attempts: 14),
                                                   bestScoreWhite: Score(success: 14, attempts: 15),
                                                   bestScoreBlack: Score(success: 9, attempts: 10),
                                                   avgScoreWhite: 10.65, totalPlayWhite: 20,
                                                   avgScoreBlack: 6.10, totalPlayBlack: 10)
    
    //    let totalPlay = 100
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
                
                gameEnded = true
                gameStarted = false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                ScrollView(Axis.Set.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(questionList, id: \.self) { item in
                            Text(item.question)
                                .font(.title2)
                                .foregroundColor(item.answer ? .green : .red)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                }
                
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
                    
                    questionList.append(Iteration(question: currentCoordinate,
                                                  answer: (clickedCoordinate == currentCoordinate)))
                    
                    currentPlay += 1
                    currentCoordinate = getRandomCoordinate()
                })
                
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .padding(.bottom, 20)
                    .padding(.top, -5)
                
                Spacer()
                if gameStarted {
                    Text(currentCoordinate)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
                HStack(spacing: 15) {
                    if !gameStarted {
                        Button {
                            gameStarted = true
                            gameEnded = false
                            showCoordinates = false
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
                            PopupOverView(showPiecesPosition: $showPiecesPosition,
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
            .navigationTitle("BoardBrain - training")
            .navigationBarTitleDisplayMode(.inline)
            .popup(isPresented: $gameEnded) {
                VStack {
                    Text("Game ended!")
                        .foregroundColor(.black)
                    
                    Text("Score: \(score)/\(currentPlay)")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()
                                        
                    VStack(alignment: .leading) {
                        Text("Average Score: ")
                            .foregroundColor(.gray)
                        Text(String(format: "as White:  %.2f \nas Black:  %.2f ", scoreModel.avgScoreWhite, scoreModel.avgScoreBlack))
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.bottom)
                        
                        Text("Best Score: ")
                            .foregroundColor(.gray)
                        Text("as White:  \(scoreModel.bestScoreWhite.success) / \(scoreModel.bestScoreWhite.attempts) \nas Black:  \(scoreModel.bestScoreBlack.success) / \(scoreModel.bestScoreBlack.attempts)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.bottom)
                    }
                    .padding(20)
                    .background(.gray.opacity(0.25))
                    .cornerRadius(15)
                }
                .padding(25)
                .background(.white)
                .cornerRadius(15)
                
            } customize: {
                $0
                    .type(.floater())
                    .position(.center)
                    .animation(.spring())
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
                    .autohideIn(60)
            }
//                .alert(isPresented: $gameEnded) {
//                    // Alert content
//                    Alert(
//                        title: Text("Game ended!"),
//                        message: Text("Score: \(score)/\(currentPlay)\n\nBest as white: 18/20\nBest as black: 18/20"),
//                        dismissButton: .default(Text("OK"))
//                    )
//                }
            .toolbar {
                // Hamburger menu icon on the left
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Option 1", action: {})
                        Button("Option 2", action: {})
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                    }
                }
                
                // Gear icon on the right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for the gear icon
                    }) {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    GameView()
}
