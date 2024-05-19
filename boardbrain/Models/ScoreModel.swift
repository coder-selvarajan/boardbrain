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
    var correctAttempts: Int = 0
    var totalAttempts: Int = 0
    var avgResponseTime: String? = "-1"
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
    
    var lastScoreCrossedBestScore: Bool? = false
    
    var whiteAvgScoreCrossedAt: Int? = 0 //represents the attempt the user crossed the common avg ascore as white piece
    var blackAvgScoreCrossedAt: Int? = 0 //... as black
}
