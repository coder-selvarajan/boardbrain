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
    let cellSize: CGFloat = 50
    @State private var piece = ChessPiece(type: ChessPieceType.allCases.randomElement()!, position: CGPoint(x: (Int.random(in: 0..<8) * 50) - Int(25.0), y: (Int.random(in: 0..<8) * 50) - Int(25.0)))  // Initially place the piece at a random point

    var body: some View {
        ZStack {
            ForEach(0..<rows, id: \.self) { row in
                ForEach(0..<columns, id: \.self) { column in
                    Rectangle()
                        .fill((row + column) % 2 == 0 ? Color.white : Color.brown)
                        .frame(width: cellSize, height: cellSize)
                        .position(x: CGFloat(column) * cellSize + cellSize / 2, y: CGFloat(row) * cellSize + cellSize / 2)
                }
            }
            Image(piece.type.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor((Int(piece.position.x / cellSize) + Int(piece.position.y / cellSize)) % 2 == 0 ? .black : .white)
                .position(piece.position)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.piece.position = gesture.location
                        }
                        .onEnded { gesture in
                            let newX = round(gesture.location.x / cellSize) * cellSize + cellSize / 2
                            let newY = round(gesture.location.y / cellSize) * cellSize + cellSize / 2
                            self.piece.position = CGPoint(x: newX, y: newY)
                        }
                )
        }
        .frame(width: cellSize * CGFloat(columns), height: cellSize * CGFloat(rows))
    }
}

#Preview {
    ChessboardView()
}
