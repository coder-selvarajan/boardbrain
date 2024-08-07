//
//  ColorsBoardView.swift
//  boardbrain
//
//  Created by Selvarajan on 14/04/24.
//

import SwiftUI

struct ColorsBoardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var showCoordinates: Bool
    @Binding var whiteSide: Bool
    @Binding var highlightIndex: Int
    @Binding var gameEnded: Bool
    @Binding var gameStarted: Bool
    let squareClicked: ((Int) -> Void)?
    
    private let rows = 8
    private let columns = 8
    private let startingPositions: [String: String] = [
        "a1": "rook-w", "b1": "knight-w", "c1": "bishop-w", "d1": "queen-w",
        "e1": "king-w", "f1": "bishop-w", "g1": "knight-w", "h1": "rook-w",
        "a2": "pawn-w", "b2": "pawn-w", "c2": "pawn-w", "d2": "pawn-w",
        "e2": "pawn-w", "f2": "pawn-w", "g2": "pawn-w", "h2": "pawn-w",
        "a7": "pawn-b", "b7": "pawn-b", "c7": "pawn-b", "d7": "pawn-b",
        "e7": "pawn-b", "f7": "pawn-b", "g7": "pawn-b", "h7": "pawn-b",
        "a8": "rook-b", "b8": "knight-b", "c8": "bishop-b", "d8": "queen-b",
        "e8": "king-b", "f8": "bishop-b", "g8": "knight-b", "h8": "rook-b"
    ]
    
    // Generate the grid layout with no spacing
    private var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible(), spacing: 0), count: columns)
    }
    
    private func getCoordinate(forIndex index: Int) -> Square {
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
        return square
    }
    
    private func pieceAt(index: Int) -> String? {
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
        
        let position = "\(file)\(rank)"
        
        return startingPositions[position] ?? ""
    }
    
    func squareTapped(index: Int) {
        squareClicked?(index)
    }
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: gridLayout, spacing: 0) {
                ForEach(0..<(rows * columns), id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor(gameStarted
                                             ? (highlightIndex == index ? .yellow : .white)
                                             : ((index / columns) % 2 == index % 2
                                                ? themeManager.boardColors.0
                                                : themeManager.boardColors.1))
                            .border(gameStarted ? Color.black.opacity(0.25) : Color.clear)
                            .onTapGesture {
                                squareTapped(index: index)
                            }
                        
                        let coordinate = getCoordinate(forIndex: index)
                        
                        if gameStarted && highlightIndex == index {
                            Text("\(coordinate.file)\(coordinate.rank)")
                                .font(.title2)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .padding([.bottom, .trailing], 3)
                        }
                        
                        if showCoordinates {
                            if index % columns == 0 {
                                Text("\(coordinate.rank)")
                                    .font(.caption2)
                                    .foregroundColor(
                                        (gameStarted ? .black.opacity(0.7) :
                                        (index / columns) % 2 == index % 2 ? themeManager.boardColors.1 : themeManager.boardColors.0))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding([.top, .leading], 2)
                            }
                            if index > 55 {
                                Text("\(coordinate.file)")
                                    .font(.caption2)
                                    .foregroundColor(
                                        (gameStarted ? .black.opacity(0.7) :
                                        (index / columns) % 2 == index % 2 ? themeManager.boardColors.1 : themeManager.boardColors.0))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                    .padding([.bottom, .trailing], 2)
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }.padding(0) // LazyGrid
            
            HStack(alignment: .center) {
                VStack {
                    Image(systemName: "chevron.compact.up")
                        .resizable()
                        .frame(width: 10, height: 5)
                        .foregroundColor(.white)
                        .padding(.bottom, -5)
                    Image(whiteSide ? "king-w" : "king-b")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(0)
                }
                Spacer()
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width,
                   maxHeight: UIScreen.main.bounds.size.width,
                   alignment: .bottomLeading)
            .padding(.bottom, -110)
            .padding(.leading, 5)
            
        }
//        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
    }
}

#Preview {
    ColorsBoardView(showCoordinates: .constant(true), whiteSide: .constant(true), highlightIndex: .constant(20), gameEnded: .constant(true), gameStarted: .constant(false), squareClicked: nil)
}
