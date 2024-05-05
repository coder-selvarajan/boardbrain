//
//  Position.swift
//  boardbrain
//
//  Created by Selvarajan on 23/04/24.
//

import Foundation

struct Position: Equatable {
    var row: Int
    var column: Int
    
    static func kingMoves(from position: Position) -> [Position] {
//        print("Position ", position)
        
        let moves = [
            (-1, -1), (-1, 0), (0, -1), (1,0), (0,1), (1, 1), (1, -1), (-1, 1)
        ].map { (dr, dc) -> Position? in
            let newRow = position.row + dr
            let newCol = position.column + dc
            if newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8 {
                return Position(row: newRow, column: newCol)
            }
            return nil
        }
        .compactMap { $0 }
        
        return moves
    }
    
    static func pawnMoves(from position: Position) -> [Position] {
//        print("Position ", position)
        
        let moves = [
            (-1, 0)
        ].map { (dr, dc) -> Position? in
            let newRow = position.row + dr
            let newCol = position.column + dc
            if newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8 {
                return Position(row: newRow, column: newCol)
            }
            return nil
        }
        .compactMap { $0 }
        
        return moves
    }
    
    static func straightMoves(from position: Position) -> [Position] {
//        print("Position ", position)
        var moves = [Position]()
        // Horizontal and vertical moves
        for i in 0..<8 {
            if i != position.row { moves.append(Position(row: i, column: position.column)) }
            if i != position.column { moves.append(Position(row: position.row, column: i)) }
        }
        return moves
    }
    
    static func diagonalMoves(from position: Position) -> [Position] {
//        print("Position ", position)
        var moves = [Position]()
        // Diagonal moves
        for i in 1..<8 {
            let directions = [(i, i), (i, -i), (-i, i), (-i, -i)]
            for (dr, dc) in directions {
                let newRow = position.row + dr
                let newCol = position.column + dc
                if newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8 {
                    moves.append(Position(row: newRow, column: newCol))
                }
            }
        }
        return moves
    }
    
    static func knightMoves(from position: Position) -> [Position] {
//        print("Position ", position)
        let moves = [
            (2, 1), (1, 2), (-1, 2), (-2, 1),
            (-2, -1), (-1, -2), (1, -2), (2, -1)
        ].map { (dr, dc) -> Position? in
            let newRow = position.row + dr
            let newCol = position.column + dc
            if newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8 {
                return Position(row: newRow, column: newCol)
            }
            return nil
        }
        .compactMap { $0 }
        
        return moves
    }
}
