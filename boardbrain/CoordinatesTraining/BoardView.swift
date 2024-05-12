//
//  BoardView.swift
//  boardbrain
//
//  Created by Selvarajan on 06/04/24.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var showPiecesPosition: Bool
    @Binding var showRanksandFiles: Bool
    @Binding var showCoordinates: Bool
    @Binding var whiteSide: Bool
    @Binding var targetIndex: Int
    @Binding var gameStarted: Bool
    
    @State var highlightResult: Bool = false
    @State var greenTargetIndex: Int = -1
    @State var redTargetIndex: Int = -1
    
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
        if !gameStarted {
            return
        }
        
        self.highlightResult = true
        greenTargetIndex = targetIndex
        if index != targetIndex {
            // red
            redTargetIndex = index
        }
        else {
            // green
            redTargetIndex = -1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.highlightResult = false
            }
        }
        squareClicked?(index)
    }
    
    
    var body: some View {
        ZStack {
            LazyVGrid(columns: gridLayout, spacing: 0) {
                ForEach(0..<(rows * columns), id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor((highlightResult && index == greenTargetIndex) ? .green : (highlightResult && index == redTargetIndex) ?
                                .red : (index / columns) % 2 == index % 2
                                             ? themeManager.boardColors.0   //Color.white
                                             : themeManager.boardColors.1)  //Color.gray)
                        //                        .foregroundColor((highlightResult && index == greenTargetIndex) ? .green : (highlightResult && index == redTargetIndex) ?
                        //                            .red : (index / columns) % 2 == index % 2
                        //                                         ? Color(hex: "#F0D9B5")
                        //                                         : Color(hex: "#B58863"))
                            .onTapGesture {
                                squareTapped(index: index)
                            }
                        
                        let coordinate = getCoordinate(forIndex: index)
                        
                        if showCoordinates {
                            if (showPiecesPosition &&  (1...2).contains(coordinate.rank)) {
                                Text("\(coordinate.file)\(coordinate.rank)")
                                    .font(.system(size: 8))
                                    .foregroundColor((index / columns) % 2 == index % 2 ? .black.opacity(0.5) : .white.opacity(0.5))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding([.top, .leading], 1)
                            }
                            else if (showPiecesPosition &&  (7...8).contains(coordinate.rank)) {
                                Text("\(coordinate.file)\(coordinate.rank)")
                                    .font(.system(size: 8))
                                    .foregroundColor((index / columns) % 2 == index % 2 ? .black.opacity(0.5) : .white.opacity(0.5))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding([.top, .leading], 1)
                                
                            } else {
                                Text("\(coordinate.file)\(coordinate.rank)")
                                    .font(.caption)
                                    .foregroundColor((index / columns) % 2 == index % 2 ? .black.opacity(0.35) : .white.opacity(0.35))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                //                                .padding([.bottom, .trailing], 3)
                            }
                        }
                        
                        if showPiecesPosition {
                            if let imageName = pieceAt(index: index), !imageName.isEmpty {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(5) // Adjust padding to your liking
                                    .onTapGesture {
                                        squareTapped(index: index)
                                    }
                            }
                        }
                        
                        if showRanksandFiles {
                            if index % columns == 0 {
                                Text("\(coordinate.rank)")
                                    .font(.caption2)
                                    .foregroundColor((index / columns) % 2 == index % 2 ? themeManager.boardColors.1 : themeManager.boardColors.0)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding([.top, .leading], 2)
                            }
                            // print 'a'
                            if index > 55 {
                                Text("\(coordinate.file)")
                                    .font(.caption2)
                                    .foregroundColor((index / columns) % 2 == index % 2 ? themeManager.boardColors.1 : themeManager.boardColors.0)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                                    .padding([.bottom, .trailing], 2)
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }.padding(0) // LazyGrid
            
            if !showPiecesPosition {
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
        }
    }
}

#Preview {
    BoardView(showPiecesPosition: .constant(true), showRanksandFiles: .constant(true), showCoordinates: .constant(false), whiteSide: .constant(true), targetIndex: .constant(-1), gameStarted: .constant(false), squareClicked: { value in
        print(value)
    })
}

#Preview {
    BoardView(showPiecesPosition: .constant(true), showRanksandFiles: .constant(true), showCoordinates: .constant(false), whiteSide: .constant(false), targetIndex: .constant(-1), gameStarted: .constant(false), squareClicked: { value in
        print(value)
    })
}

#Preview {
    BoardView(showPiecesPosition: .constant(false), showRanksandFiles: .constant(false), showCoordinates: .constant(true), whiteSide: .constant(true), targetIndex: .constant(-1), gameStarted: .constant(false), squareClicked: { value in
        print(value)
    })
}

#Preview {
    BoardView(showPiecesPosition: .constant(false), showRanksandFiles: .constant(false), showCoordinates: .constant(false), whiteSide: .constant(true), targetIndex: .constant(-1), gameStarted: .constant(false), squareClicked: { value in
        print(value)
    })
}
