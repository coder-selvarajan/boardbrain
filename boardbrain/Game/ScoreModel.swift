//
//  ScoreModel.swift
//  boardbrain
//
//  Created by Selvarajan on 13/04/24.
//

import Foundation

struct Score {
    var success: Int = 14
    var attempts: Int = 15
}

struct ScoreModel {
    var lastScore: Score
    var bestScoreWhite: Score
    var bestScoreBlack: Score
    
    var avgScoreWhite: Float
    var totalPlayWhite: Int
    var avgScoreBlack: Float
    var totalPlayBlack: Int
}
