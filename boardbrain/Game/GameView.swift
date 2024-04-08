//
//  GameView.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI

struct GameView: View {
    @State private var showPiecesPosition = true
    @State private var showRanksandFiles = true
    @State private var showCoordinates = false
    
//    private let rows = 8
    private let columns = 8
    
    @State var currentCoordinate: String = ""
    @State var points: Int = 0
    @State var gameStarted: Bool = false
    @State var gameEnded: Bool = false
    @State var currentPlay: Int = 0
    let totalPlay = 10
    
    private func getCoordinate(forIndex index: Int) -> String {
        let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let rank = 8 - index / columns
        let file = files[index % columns]
        
        let square = Square(rank: rank, file: file, index: index)
        return square.getCoordinate()
    }
    
    func getRandomCoordinate() -> String {
        let rndIndex = Int.random(in: 0..<64)
        return getCoordinate(forIndex: rndIndex)
    }
    
    var body: some View {
        ScrollView {
            
            Text("Board Game")
                .font(.largeTitle)
                .padding(.bottom, 10)
            
            Divider()
            HStack(alignment: .top) {
                
                    Toggle("Pieces", isOn: $showPiecesPosition)
                        .font(.subheadline)
                        .padding(.horizontal)
                    
                    Toggle("Coordinates", isOn: $showRanksandFiles)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.bottom)
            }
            Divider()
            
            BoardView(showPiecesPosition: $showPiecesPosition,
                      showRanksandFiles: $showRanksandFiles,
                      showCoordinates: $showCoordinates,
                      squareClicked: { value in
                // game logic, validating clicked squares
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
            .padding(.bottom, 20)
            
            if !gameEnded {
                Text(currentCoordinate)
                    .font(.largeTitle)
                    .padding()
            }
            
            if gameEnded {
                Text("Game ended!")
            }
            if gameStarted || gameEnded {
                Text("Points: \(points)/\(totalPlay)")
                    .font(.title3)
                    .foregroundColor(.green)
                    .padding()
            }
            
            if !gameStarted {
                Button {
                    gameStarted = true
                    gameEnded = false
                    showCoordinates = false
                    currentCoordinate = getRandomCoordinate()
                    currentPlay = 1
                    points = 0
                } label: {
                    Text("Start Game")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.blue)
                        .cornerRadius(10.0)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.95))
        
    }
}

#Preview {
    GameView()
}
