//
//  GameIteration.swift
//  boardbrain
//
//  Created by Selvarajan on 14/04/24.
//

import Foundation

struct GameIteration: Hashable {
    var id: UUID = UUID()
    var question : String
    var answer : Bool
}

//struct ColorGameIteration: Hashable {
//    var id: UUID = UUID()
//    var selectedSquareIndex: Int
//    var selectedSquareLabel : String
//    var answer : SquareColor?
//    var correctAnswer : SquareColor
//}
