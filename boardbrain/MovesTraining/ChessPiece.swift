//
//  ChessPiece.swift
//  boardbrain
//
//  Created by Selvarajan on 19/04/24.
//

import Foundation

//enum ChessPieceType: String, CaseIterable {
//    case king, queen, rook, bishop, knight, pawn
//}
//
//struct ChessPiece : Identifiable {
//    let id = UUID()
//    var type: ChessPieceType
//    var position: (Int, Int)
//}

//struct ChessPiece: Identifiable {
//    var id = UUID()
//    var type: ChessPieceType
//    var position: CGPoint  // Using CGPoint to track the position in pixels rather than grid coordinates
//}

struct ChessPiece: Identifiable {
    let id = UUID()
    var type: ChessPieceType
    var row: Int
    var column: Int
}

enum ChessPieceType: String, CaseIterable {
    case king, queen, rook, bishop, knight, pawn
}

//enum ChessPieceType: String, CaseIterable {
//    case king = "crown", queen = "rosette", rook = "castle", bishop = "bell", knight = "hare", pawn = "capsule"
//}
