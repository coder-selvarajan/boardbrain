//
//  ChessBoard.swift
//  boardbrain
//
//  Created by Selvarajan on 23/04/24.
//

import SwiftUI

struct XChessBoardHome: View {
    var body: some View {
        xChessBoard()
    }
}

struct xChessBoard: View {
    let rows = 8
    let columns = 8
    @State private var board: [[xChessPiece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
    @State private var possibleMoves: [xPosition] = []

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        xSquareView(isLight: (row + column) % 2 == 0, piece: board[row][column], isPossibleMove: possibleMoves.contains(where: { $0.row == row && $0.column == column }))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                placeRandomPiece()
                            }
                    }
                }
            }
        }
        .onAppear {
            placeRandomPiece()
        }
    }
    
    func placeRandomPiece() {
        // Clear the board and possible moves
        board = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        possibleMoves = []

        // Select random piece and position
        let pieces: [xChessPiece] = [.rook, .knight, .bishop, .queen]
        let randomPiece = pieces.randomElement()!
        let randomRow = Int.random(in: 0..<rows)
        let randomColumn = Int.random(in: 0..<columns)
        
        // Place the piece
        board[randomRow][randomColumn] = randomPiece
        
        // Calculate moves
        possibleMoves = randomPiece.possibleMoves(from: xPosition(row: randomRow, column: randomColumn), boardSize: (rows, columns))
        
        print(possibleMoves)
    }
}

struct xSquareView: View {
    var isLight: Bool
    var piece: xChessPiece?
    var isPossibleMove: Bool

    var body: some View {
        Color(isLight ? .white : .gray)
            .overlay(
                ZStack {
                    if isPossibleMove {
                        Text("●")
                            .font(.body)
                            .foregroundColor(.green)
                    }
                    
                    Text(piece?.symbol ?? "")
                        .font(.largeTitle)
                        .foregroundColor(isPossibleMove ? .red : .black)
                }
            )
            .border(Color.black, width: 0)
    }
}

enum xChessPiece {
    case rook, knight, bishop, queen
    
    var symbol: String {
        switch self {
        case .rook:
            return "♜"
        case .knight:
            return "♞"
        case .bishop:
            return "♝"
        case .queen:
            return "♛"
        }
    }
    
    func possibleMoves(from position: xPosition, boardSize: (Int, Int)) -> [xPosition] {
        switch self {
        case .rook:
            return xPosition.straightMoves(from: position, boardSize: boardSize)
        case .knight:
            return xPosition.knightMoves(from: position, boardSize: boardSize)
        case .bishop:
            return xPosition.diagonalMoves(from: position, boardSize: boardSize)
        case .queen:
            return  xPosition.straightMoves(from: position, boardSize: boardSize) +
                    xPosition.diagonalMoves(from: position, boardSize: boardSize)
        }
    }
}

struct xPosition: Equatable {
    var row: Int
    var column: Int
    
    static func straightMoves(from position: xPosition, boardSize: (Int, Int)) -> [xPosition] {
        var moves = [xPosition]()
        // Horizontal and vertical moves
        for i in 0..<boardSize.0 {
            if i != position.row { moves.append(xPosition(row: i, column: position.column)) }
            if i != position.column { moves.append(xPosition(row: position.row, column: i)) }
        }
        return moves
    }
    
    static func diagonalMoves(from position: xPosition, boardSize: (Int, Int)) -> [xPosition] {
        var moves = [xPosition]()
        // Diagonal moves
        let maxDistance = max(boardSize.0, boardSize.1)
        for i in 1..<maxDistance {
            let directions = [(i, i), (i, -i), (-i, i), (-i, -i)]
            for (dr, dc) in directions {
                let newRow = position.row + dr
                let newCol = position.column + dc
                if newRow >= 0 && newRow < boardSize.0 && newCol >= 0 && newCol < boardSize.1 {
                    moves.append(xPosition(row: newRow, column: newCol))
                }
            }
        }
        return moves
    }
    
    static func knightMoves(from position: xPosition, boardSize: (Int, Int)) -> [xPosition] {
        let moves = [
            (2, 1), (1, 2), (-1, 2), (-2, 1),
            (-2, -1), (-1, -2), (1, -2), (2, -1)
        ].map { (dr, dc) -> xPosition? in
            let newRow = position.row + dr
            let newCol = position.column + dc
            if newRow >= 0 && newRow < boardSize.0 && newCol >= 0 && newCol < boardSize.1 {
                return xPosition(row: newRow, column: newCol)
            }
            return nil
        }
        .compactMap { $0 }
        
        return moves
    }
}
