//
//  ChessBoardView.swift
//  boardbrain
//
//  Created by Selvarajan on 19/04/24.
//

import SwiftUI

struct MovesBoardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("hapticFeedback") private var hapticFeedbackEnabled = true
    
    let rows = 8
    let columns = 8
    @Binding var showCoordinates: Bool
    @Binding var highlightPossibleMoves: Bool
    @Binding var whiteSide: Bool
    @Binding var gameState: GameState?
    
    @State var imageScale: CGSize = CGSize(width: 1.0, height: 1.0)
    @State var highlightedRow: Int = -1
    @State var highlightedCol: Int = -1
    @State var imageOffset: CGSize = .zero
    @State var gestureLocation: CGPoint = .zero
    @State var movedPosition: Position = Position(row: -1, column: -1)
    
    @State var highlightResult: Bool = false
    @State var correctAnswer: Bool = false
    
    let rank = ["a","b","c","d","e","f","g","h"]
    
    let pieceMovedTo: ((Position) -> Void)?
    
    func validateUserAnswer(row: Int, column: Int) {
        if (gameState == nil || gameState!.gameEnded) {
            return
        }
        
        let targetPosition = Position(row: row, column: column)
        
        // review the answer and highlight it accordingly
        if targetPosition == gameState?.targetPosition {
            correctAnswer = true
        }
        else {
            correctAnswer = false
        }
        
        imageOffset = .zero
        imageScale = CGSize(width: 1.0, height: 1.0)
        
        highlightedCol = -1
        highlightedRow = -1
        
        if gameState!.possibleMoves.contains(targetPosition) {
            // dont highlight the piece initial position
            gameState!.highlightInititalPieceSquare = false
            
            movedPosition = targetPosition
            
            gameState!.currentPiece.column = column
            gameState!.currentPiece.row = row
            
            // generate a mild haptic feedback
            if hapticFeedbackEnabled {
                performRigidHapticFeedback()
            }

            //call back for piece movement
            pieceMovedTo!(targetPosition)
            
            //highlight for half a sec
            triggerResultHighlight()
        }
    }
    
    func triggerResultHighlight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.highlightResult = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.highlightResult = false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(columns)
            ZStack {
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        ZStack {
                            Rectangle()
                                .foregroundStyle((row + column) % 2 == 0 ? themeManager.boardColors.0 : themeManager.boardColors.1)
                                .frame(width: cellSize, height: cellSize)
                                .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                          y: CGFloat(row) * cellSize + cellSize / 2)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        validateUserAnswer(row: row, column: column)
                                    }
                                }
                            
                            if gameState != nil && !gameState!.gameEnded {
                                if highlightPossibleMoves {
                                    if gameState!.possibleMoves.contains(Position(row: row, column: column)) {
                                        Circle()
                                            .fill(.green.opacity(0.5))
                                            .frame(width: cellSize * 0.25, height: cellSize * 0.25)
                                            .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                                      y: CGFloat(row) * cellSize + cellSize / 2)
                                    }
                                }
                            }
                            
                            if showCoordinates {
                                if column == 0 {
                                    Text(whiteSide ? "\(Int(8 - row))" : "\(row + 1)")
                                        .font(.caption2)
                                        .foregroundColor(row % 2 == 0 ? themeManager.boardColors.1 : themeManager.boardColors.0)
                                        .frame(width: cellSize, height: cellSize, alignment: .topLeading)
                                        .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                                  y: CGFloat(row) * cellSize + cellSize / 2)
                                        .padding([.top, .leading], 2)
                                }
                                // print 'a'
                                if row == 7 {
                                    Text(whiteSide ? rank[column] : rank.reversed()[column])
                                        .font(.caption2)
                                        .foregroundColor(column % 2 == 0 ? themeManager.boardColors.0 : themeManager.boardColors.1)
                                        .frame(width: cellSize, height: cellSize, alignment: .bottomTrailing)
                                        .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                                  y: CGFloat(row) * cellSize + cellSize / 2)
                                        .padding([.bottom, .trailing], 2)
                                }
                            }
                        }
                    }
                }
                
                //Highlighting the square with green or red
                if highlightResult && gameState != nil && !gameState!.gameEnded {
                    ZStack {
                        Rectangle()
                            .fill(correctAnswer ? .green : .red)
                            .frame(width: cellSize, height: cellSize)
                            .position(x: CGFloat(gameState!.currentPiece.column) * cellSize + cellSize / 2,
                                      y: CGFloat(gameState!.currentPiece.row) * cellSize + cellSize / 2)
                    }
                }
                
                //Highlighting the initial piece position
                if gameState != nil && gameState!.highlightInititalPieceSquare && !gameState!.gameEnded {
                    ZStack {
                        Rectangle()
                            .fill(Color.init(hex: "FEF474"))
                            .frame(width: cellSize, height: cellSize)
                            .position(x: CGFloat(gameState!.currentPiece.column) * cellSize + cellSize / 2,
                                      y: CGFloat(gameState!.currentPiece.row) * cellSize + cellSize / 2)
                    }
                }
                
                // Highlighting the square while moving the piece
                if gameState != nil && !gameState!.gameEnded {
                    if (highlightedRow > -1 && highlightedCol > -1) {
                        ZStack {
                            Circle()
                                .fill(.black.opacity(0.15))
                                .frame(width: cellSize * 2, height: cellSize * 2)
                                .position(x: CGFloat(highlightedCol) * cellSize + cellSize / 2, y: CGFloat(highlightedRow) * cellSize + cellSize / 2)
                            
                            Rectangle()
                                .fill(Color.init(hex: "FEF474"))
                                .frame(width: cellSize, height: cellSize)
                                .position(x: CGFloat(highlightedCol) * cellSize + cellSize / 2,
                                          y: CGFloat(highlightedRow) * cellSize + cellSize / 2)
                        }
                    }
                    
                    // Random Chess piece
                    Image(gameState!.currentPiece.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(imageScale)
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                        .foregroundColor((gameState!.currentPiece.row + gameState!.currentPiece.column) % 2 == 0 ? .black : .white)
                        .position(x: CGFloat(gameState!.currentPiece.column) * cellSize + cellSize / 2, y: CGFloat(gameState!.currentPiece.row) * cellSize + cellSize / 2)
                        .offset(imageOffset)
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    // lock
                                    // Handle tap gesture
                                    print("Image tapped")
                                    // Add your tap gesture handling code here
                                }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    highlightResult = false
                                    gestureLocation = gesture.location
                                    let newColumn = Int((gesture.location.x / cellSize)) //.rounded())
                                    let newRow = Int((gesture.location.y / cellSize)) //.rounded())
                                    if newColumn < 0 || newColumn > 7 || newRow < 0 || newRow > 7 {
                                        // disabling highlights while dragging outside of the board
                                        highlightedCol = -1
                                        highlightedRow = -1
                                    }
                                    else {
                                        highlightedCol = newColumn
                                        highlightedRow = newRow
                                    }
                                    imageOffset = gesture.translation
                                    imageScale = CGSize(width: 2, height: 2)
                                }
                                .onEnded { gesture  in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        let newColumn = Int((gesture.location.x / cellSize)) //.rounded())
                                        let newRow = Int((gesture.location.y / cellSize)) //.rounded())
                                        
                                        validateUserAnswer(row: newRow, column: newColumn)
                                    }
                                }
                        ) //gesture
                }// piece nil condition
                
                // Board side indicator
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
            .onReceive([self.gameState].publisher.first()) { (state) in
                if state != nil {
                    if state!.gameEnded {
                        imageOffset = .zero
                        imageScale = CGSize(width: 1.0, height: 1.0)
                        
                        highlightedCol = -1
                        highlightedRow = -1
                    }
                }
            }
            .background(.yellow)
            .foregroundColor(.yellow)
            .frame(width: geometry.size.width, height: geometry.size.width) // Keeping the board square
        }
    }
}

#Preview {
    MovesBoardView(showCoordinates: .constant(true), highlightPossibleMoves: .constant(false),
                   whiteSide: .constant(true),
                   gameState: .constant(nil),
                   pieceMovedTo: { value in
        print(value)
    })
    .background(.black)
}
