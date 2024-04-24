//
//  ChessBoardView.swift
//  boardbrain
//
//  Created by Selvarajan on 19/04/24.
//

import SwiftUI

struct ChessboardView: View {
    let rows = 8
    let columns = 8
    @Binding var piece: ChessPiece?
    @Binding var possibleMoves: [Position]?
    @Binding var showCoordinates: Bool
    
    @State var imageScale: CGSize = CGSize(width: 1.0, height: 1.0)
    @State var highlightedRow: Int = -1
    @State var highlightedCol: Int = -1
    @State var imageOffset: CGSize = .zero
    @State var gestureLocation: CGPoint = .zero
    
    let rank = ["a","b","c","d","e","f","g","h","i","j"]
    
    var body: some View {
        GeometryReader { geometry in
            let cellSize = geometry.size.width / CGFloat(columns)
            ZStack {
                
                
                ForEach(0..<rows, id: \.self) { row in
                    ForEach(0..<columns, id: \.self) { column in
                        ZStack {
                            Rectangle()
                                .fill((row + column) % 2 == 0 ? Color.white : Color.gray)
                            //                            .fill(
                            //                                (row == highlightedRow && column == highlightedCol) ? Color.green : Color.clear)
                                .frame(width: cellSize, height: cellSize)
                                .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                          y: CGFloat(row) * cellSize + cellSize / 2)
                            
                            if let possibleMoves = possibleMoves {
                                if possibleMoves.contains(Position(row: row, column: column)) {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: cellSize * 0.25, height: cellSize * 0.25)
                                        .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                                  y: CGFloat(row) * cellSize + cellSize / 2)
                                }
                            }
                            
                            if showCoordinates {
                                if column == 0 {
                                    Text("\(8 - row)")
                                        .font(.caption2)
                                        .foregroundColor(row % 2 == 0 ? .gray : .white)
                                        .frame(width: cellSize, height: cellSize, alignment: .topLeading)
                                        .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                                  y: CGFloat(row) * cellSize + cellSize / 2)
                                        .padding([.top, .leading], 1)
                                }
                                // print 'a'
                                if row == 7 {
                                    Text("\(rank[column])")
                                        .font(.caption2)
                                        .foregroundColor(column % 2 == 0 ? .white : .gray)
                                        .frame(width: cellSize, height: cellSize, alignment: .bottomTrailing)
                                        .position(x: CGFloat(column) * cellSize + cellSize / 2,
                                                  y: CGFloat(row) * cellSize + cellSize / 2)
                                        .padding([.bottom, .trailing], 2)
                                }
                            }
                        }
                    }
                }
                
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
                if var piece = piece {
                    Image(piece.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(imageScale)
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                        .foregroundColor((piece.row + piece.column) % 2 == 0 ? .black : .white)
                        .position(x: CGFloat(piece.column) * cellSize + cellSize / 2, y: CGFloat(piece.row) * cellSize + cellSize / 2)
                        .offset(imageOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    gestureLocation = gesture.location
                                    let newColumn = Int((gesture.location.x / cellSize)) //.rounded())
                                    let newRow = Int((gesture.location.y / cellSize)) //.rounded())
                                    highlightedCol = newColumn
                                    highlightedRow = newRow
                                    imageOffset = gesture.translation
                                    
                                    imageScale = CGSize(width: 1.5, height: 1.5)
                                    
                                }
                                .onEnded { gesture  in
                                    withAnimation {
                                        let newColumn = Int((gesture.location.x / cellSize)) //.rounded())
                                        let newRow = Int((gesture.location.y / cellSize)) //.rounded())
                                        piece.column = newColumn
                                        piece.row = newRow
                                        imageOffset = .zero
                                        imageScale = CGSize(width: 1.0, height: 1.0)
                                        
                                        highlightedCol = -1
                                        highlightedRow = -1
                                    }
                                }
                        )
                }// piece nil condition
                
                //                Text(String.init(format: "%.2f, %.2f", gestureLocation.x, gestureLocation.y))
                //                    .foregroundColor(.red)
            }
            .background(.yellow)
            .foregroundColor(.yellow)
            .frame(width: geometry.size.width, height: geometry.size.width) // Keeping the board square
        }
    }
    
}

#Preview {
    ChessboardView(piece: .constant(ChessPiece(type: ChessPieceType.allCases.randomElement()!,
                                     row: Int.random(in: 0..<8),
                                               column: Int.random(in: 0..<8))), 
                   possibleMoves: .constant([]),
                   showCoordinates: .constant(false))
        .background(.black)
}
