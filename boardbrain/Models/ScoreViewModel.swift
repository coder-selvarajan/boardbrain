//
//  ColorsScoreViewModel.swift
//  boardbrain
//
//  Created by Selvarajan on 26/04/24.
//

import Foundation

enum TrainingType {
    case Coordinates, Moves, Colors
    
    func getDBKey() -> String {
        switch self {
        case .Coordinates:
            return "coordinatesTrainingScore"
        case .Colors:
            return "colorsTrainingScore"
        case .Moves:
            return "movesTrainingScore"
        }
        
    }
}

class ScoreViewModel: ObservableObject {
    @Published var scoreModel: ScoreModel
    var trainingType: TrainingType = .Coordinates
    
    init(type: TrainingType) {
        self.trainingType = type
        
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: type.getDBKey()) { //} "colorsTrainingScores") {
            if let loadedScores = try? decoder.decode(ScoreModel.self, from: data) {
                scoreModel = loadedScores
                return
            }
        }
        
        //if no user defaults value then assign default values.
        scoreModel = ScoreModel(lastScore: Score(correctAttempts: 0, totalAttempts: 0),
                                lastScoreAs: .white,
                                bestScoreWhite: Score(correctAttempts: 0, totalAttempts: 0),
                                bestScoreBlack: Score(correctAttempts: 0, totalAttempts: 0),
                                avgScoreWhite: 0.0, totalPlayWhite: 0,
                                avgScoreBlack: 0.0, totalPlayBlack: 0)
    }
    
    func updateScore(for color: COLOR, score: Score) {
        scoreModel.lastScore = score
        scoreModel.lastScoreAs = color
        
        if color == .white {
            // check and update best score
            if  (score.correctAttempts > scoreModel.bestScoreWhite.correctAttempts) ||
                (score.correctAttempts == scoreModel.bestScoreWhite.correctAttempts
                 && score.totalAttempts < scoreModel.bestScoreWhite.totalAttempts) {
                scoreModel.bestScoreWhite = score
            }
            
            // update average score
            var newAvgScore: Float = 0.0
            let newTotalPlay = scoreModel.totalPlayWhite + 1
            newAvgScore = (( scoreModel.avgScoreWhite * Float(scoreModel.totalPlayWhite)) + Float(score.correctAttempts)) / Float(newTotalPlay)
            scoreModel.avgScoreWhite = newAvgScore
            scoreModel.totalPlayWhite = newTotalPlay
            
        } else { //black
            if  (score.correctAttempts > scoreModel.bestScoreBlack.correctAttempts) ||
                (score.correctAttempts == scoreModel.bestScoreBlack.correctAttempts
                 && score.totalAttempts < scoreModel.bestScoreBlack.totalAttempts) {
                scoreModel.bestScoreBlack = score
            }
            
            // update average score
            var newAvgScore: Float = 0.0
            let newTotalPlay = scoreModel.totalPlayBlack + 1
            newAvgScore = (( scoreModel.avgScoreBlack * Float(scoreModel.totalPlayBlack)) + Float(score.correctAttempts)) / Float(newTotalPlay)
            scoreModel.avgScoreBlack = newAvgScore
            scoreModel.totalPlayBlack = newTotalPlay
        }
        
        persistScore()
    }
    
    func persistScore() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(scoreModel) {
            UserDefaults.standard.set(encoded, forKey: trainingType.getDBKey()) //"colorsTrainingScores")
            UserDefaults.standard.synchronize()
        }
    }
}
