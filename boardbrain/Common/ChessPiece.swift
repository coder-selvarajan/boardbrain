//
//  ChessPiece.swift
//  boardbrain
//
//  Created by Selvarajan on 19/04/24.
//

import Foundation

struct ChessPiece: Identifiable {
    let id = UUID()
    var type: ChessPieceType
    var row: Int
    var column: Int
}

enum ChessPieceType: String, CaseIterable {
    case king, queen, rook, bishop, knight, pawn
    
    func getShortCode() -> String {
        switch self {
        case .king:
            return "K"
        case .queen:
            return "Q"
        case .rook:
            return "R"
        case .bishop:
            return "B"
        case .knight:
            return "N"
        case .pawn:
            return "P"
        }
    }
}
