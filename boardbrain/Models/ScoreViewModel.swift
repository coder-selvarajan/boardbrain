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
    @Published var coordinatesScoreModel: ScoreModel
    @Published var movesScoreModel: ScoreModel
    @Published var colorsScoreModel: ScoreModel
    
    static func loadScoreFromUserDefaults(type: TrainingType) -> ScoreModel {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: type.getDBKey()) { //} "colorsTrainingScores") {
            if let loadedScores = try? decoder.decode(ScoreModel.self, from: data) {
                return loadedScores
            }
        }
        
        //if no user defaults value then assign default values.
        return ScoreModel(lastScore: Score(correctAttempts: 0, totalAttempts: 0),
                                lastScoreAs: .white,
                                bestScoreWhite: Score(correctAttempts: 0, totalAttempts: 0),
                                bestScoreBlack: Score(correctAttempts: 0, totalAttempts: 0),
                                avgScoreWhite: 0.0, totalPlayWhite: 0,
                                avgScoreBlack: 0.0, totalPlayBlack: 0)
    }
    
    init() {
        coordinatesScoreModel = ScoreViewModel.loadScoreFromUserDefaults(type: TrainingType.Coordinates)
        movesScoreModel = ScoreViewModel.loadScoreFromUserDefaults(type: TrainingType.Moves)
        colorsScoreModel = ScoreViewModel.loadScoreFromUserDefaults(type: TrainingType.Colors)
    }
    
    func resetScore(for type: TrainingType){
        switch type {
        case .Coordinates:
            coordinatesScoreModel = getDefaultScore()
            persistScore(type: type, scoreModel: coordinatesScoreModel)
        case .Moves:
            movesScoreModel = getDefaultScore()
            persistScore(type: type, scoreModel: movesScoreModel)
        case .Colors:
            colorsScoreModel = getDefaultScore()
            persistScore(type: type, scoreModel: colorsScoreModel)
        }
    }
    
    
    func updateScore(type: TrainingType, color: COLOR, score: Score) {
        switch type {
        case .Coordinates:
            calculateScore(for: color, score: score, scoreModel: &coordinatesScoreModel)
            persistScore(type: type, scoreModel: coordinatesScoreModel)
        case .Moves:
            calculateScore(for: color, score: score, scoreModel: &movesScoreModel)
            persistScore(type: type, scoreModel: movesScoreModel)
        case .Colors:
            calculateScore(for: color, score: score, scoreModel: &colorsScoreModel)
            persistScore(type: type, scoreModel: colorsScoreModel)
        }
    }
    
    private func getDefaultScore() -> ScoreModel {
        return ScoreModel(lastScore: Score(correctAttempts: 0, totalAttempts: 0),
                                lastScoreAs: .white,
                                bestScoreWhite: Score(correctAttempts: 0, totalAttempts: 0),
                                bestScoreBlack: Score(correctAttempts: 0, totalAttempts: 0),
                                avgScoreWhite: 0.0, totalPlayWhite: 0,
                                avgScoreBlack: 0.0, totalPlayBlack: 0)
    }
    
    private func calculateScore(for color: COLOR, score: Score, scoreModel: inout ScoreModel) {
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
    }
    
    private func persistScore(type: TrainingType, scoreModel: ScoreModel) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(scoreModel) {
            UserDefaults.standard.set(encoded, forKey: type.getDBKey()) //"colorsTrainingScores"
            UserDefaults.standard.synchronize()
        }
    }
}
