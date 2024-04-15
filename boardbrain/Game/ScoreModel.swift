//
//  ScoreModel.swift
//  boardbrain
//
//  Created by Selvarajan on 13/04/24.
//

import Foundation

enum COLOR: Codable {
    case white
    case black
}

enum SquareColor: Codable {
    case light
    case dark
}


struct Score: Codable {
    var correctAttempts: Int = 14
    var totalAttempts: Int = 15
}

struct ScoreModel: Codable {
    var lastScore: Score
    var lastScoreAs: COLOR
    var bestScoreWhite: Score
    var bestScoreBlack: Score
    
    var avgScoreWhite: Float
    var totalPlayWhite: Int
    var avgScoreBlack: Float
    var totalPlayBlack: Int
}
