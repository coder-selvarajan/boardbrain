//
//  GameView.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI

struct PopupView: View {
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

struct GameView: View {
    @State private var showPiecesPosition = true
    @State private var showRanksandFiles = true
    @State private var showCoordinates = false
    @State private var whiteSide = true
    @State private var selectedColor = "White"
    @State private var targetIndex: Int = -1
    
    private let columns = 8
    
    @State var currentCoordinate: String = ""
    @State var points: Int = 0
    @State var gameStarted: Bool = false
    @State var gameEnded: Bool = false
    @State var currentPlay: Int = 0
    @State private var progress: Float = 0.0
    
    @State private var showingOptionsPopup = false
    
    let totalPlay = 20
    
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
                currentPlay = 0
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                
//                HStack(alignment: .center) {
//                    Spacer()
//                    
//                    HStack(spacing: 0) {
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(whiteSide ? .green : .gray)
//                                .frame(width: 40, height: 40)
//                                .clipShape(RoundedCorner(radius: 5, corners: [.topLeft, .bottomLeft]))
//                                .padding(0)
//                            
//                            
//                            Image("king-w")
//                                .resizable()
//                                .frame(width: 35, height: 35)
//                                .aspectRatio(contentMode: .fit)
//                                .onTapGesture {
//                                    whiteSide = !whiteSide
//                                }
//                        }.onTapGesture {
//                            whiteSide = !whiteSide
//                        }
//                        
//                        ZStack {
//                            Rectangle()
//                                .foregroundColor(!whiteSide ? .green : .gray)
//                                .frame(width: 40, height:40)
//                                .clipShape(RoundedCorner(radius: 5, corners: [.topRight, .bottomRight]))
//                                .padding(0)
//                            
//                            Image("king-b")
//                                .resizable()
//                                .frame(width: 35, height: 35)
//                                .aspectRatio(contentMode: .fit)
//                                .onTapGesture {
//                                    whiteSide = !whiteSide
//                                }
//                        }
//                        .onTapGesture {
//                            whiteSide = !whiteSide
//                        }
//                    } //HStack
//                    .padding(0)
//                    
//                    Spacer()
//                    HStack(spacing: 0) {
//                        Toggle("Pieces", isOn: $showPiecesPosition)
//                            .toggleStyle(TickToggleStyle())
//                            .padding()
//                        
//                        
//                        Toggle("Coordinates", isOn: $showRanksandFiles)
//                            .toggleStyle(TickToggleStyle())
//                            .padding()
//                    }
//                }
//                .padding(.vertical, 5)
//                .background(.white.opacity(0.10))

                HStack {
                    EmptyView()
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
                    if gameEnded {
                        return
                    }
                    
                    let clickedCoordinate = getCoordinate(forIndex: value)
                    if clickedCoordinate == currentCoordinate {
                        // point count increases
                        points += 1
                    }
                    
                    currentPlay += 1
                    if currentPlay > totalPlay {
                        // game ended here
                        gameEnded = true
                        gameStarted = false
                        currentPlay = 0
                    }
                    else {
                        // next play
                        currentCoordinate = getRandomCoordinate()
                    }
                })
//                .padding(0)
                
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.green))
                    .scaleEffect(x: 1, y: 3, anchor: .center)
                    .padding(.bottom, 20)
                    .padding(.top, -5)
                
                
                
                if !gameEnded {
                    Text(currentCoordinate)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                }
                
                if gameEnded {
                    Text("Game ended!")
                        .foregroundColor(.white)
                }
                if gameStarted || gameEnded {
                    Text("Points: \(points)/\(totalPlay)")
                        .font(.title3)
                        .foregroundColor(.green)
                        .padding()
                }
                HStack {
                    if !gameStarted {
                        Button {
                            gameStarted = true
                            gameEnded = false
                            showCoordinates = false
                            currentCoordinate = getRandomCoordinate()
                            currentPlay = 1
                            points = 0
                            
                            startProgress()
                        } label: {
                            Text("Start Game")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(.blue)
                                .cornerRadius(10.0)
                        }
                    }
                    
                    Button {
                        showingOptionsPopup = true
                    } label: {
                        Text("⛭  Options")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.cyan)
                            .cornerRadius(10.0)
                    }
                    .popover(isPresented: $showingOptionsPopup, content: {
                        PopupView(showPiecesPosition: $showPiecesPosition,
                                  showRanksandFiles: $showRanksandFiles,
                                  whiteSide: $whiteSide)
                        .presentationDetents([.medium])
                    })
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.20))
            .navigationTitle("BoardBrain - Games")
            .navigationBarTitleDisplayMode(.inline)
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
