//
//  ColorsScoreViewModel.swift
//  boardbrain
//
//  Created by Selvarajan on 26/04/24.
//

import Foundation

enum TrainingType : String {
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
    
    var commonAverageScore: Int {
        switch self {
        case .Coordinates:
            return 10
        case .Moves:
            return 8
        case .Colors:
            return 10
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
        return ScoreModel(lastScore: Score(),
                          lastScoreAs: .white,
                          bestScoreWhite: Score(),
                          bestScoreBlack: Score(),
                          avgScoreWhite: 0.0, totalPlayWhite: 0,
                          avgScoreBlack: 0.0, totalPlayBlack: 0,
                          lastScoreCrossedBestScore: false,
                          whiteAvgScoreCrossedAt: 0, blackAvgScoreCrossedAt: 0)
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
            calculateScore(for: type, color: color, score: score, scoreModel: &coordinatesScoreModel)
            persistScore(type: type, scoreModel: coordinatesScoreModel)
        case .Moves:
            calculateScore(for: type, color: color, score: score, scoreModel: &movesScoreModel)
            persistScore(type: type, scoreModel: movesScoreModel)
        case .Colors:
            calculateScore(for: type, color: color, score: score, scoreModel: &colorsScoreModel)
            persistScore(type: type, scoreModel: colorsScoreModel)
        }
    }
    
    private func getDefaultScore() -> ScoreModel {
        return ScoreModel(lastScore: Score(),
                          lastScoreAs: .white,
                          bestScoreWhite: Score(),
                          bestScoreBlack: Score(),
                          avgScoreWhite: 0.0, totalPlayWhite: 0,
                          avgScoreBlack: 0.0, totalPlayBlack: 0,
                          lastScoreCrossedBestScore: false,
                          whiteAvgScoreCrossedAt: 0, blackAvgScoreCrossedAt: 0)
    }
    
    private func calculateScore(for type: TrainingType, color: COLOR, score: Score, scoreModel: inout ScoreModel) {
        scoreModel.lastScore = score
        scoreModel.lastScoreAs = color
        scoreModel.lastScoreCrossedBestScore = false
        
        if color == .white {
            // check and update best score
            if  (score.correctAttempts > scoreModel.bestScoreWhite.correctAttempts) ||
                (score.correctAttempts == scoreModel.bestScoreWhite.correctAttempts
                 && score.totalAttempts < scoreModel.bestScoreWhite.totalAttempts) {
                scoreModel.lastScoreCrossedBestScore = true //recording that the user has crossed his last best score
                scoreModel.bestScoreWhite = score
            }
            
            // update average score
            var newAvgScore: Float = 0.0
            let newTotalPlay = scoreModel.totalPlayWhite + 1
            newAvgScore = (( scoreModel.avgScoreWhite * Float(scoreModel.totalPlayWhite)) + Float(score.correctAttempts)) / Float(newTotalPlay)
            scoreModel.avgScoreWhite = newAvgScore
            scoreModel.totalPlayWhite = newTotalPlay
            
            // updating whether the user crossed the common average score..
            if score.correctAttempts >= type.commonAverageScore
                && (scoreModel.whiteAvgScoreCrossedAt == nil || scoreModel.whiteAvgScoreCrossedAt! == 0) {
                scoreModel.whiteAvgScoreCrossedAt = newTotalPlay
            }
            
        } else { //black
            if  (score.correctAttempts > scoreModel.bestScoreBlack.correctAttempts) ||
                (score.correctAttempts == scoreModel.bestScoreBlack.correctAttempts
                 && score.totalAttempts < scoreModel.bestScoreBlack.totalAttempts) {
                scoreModel.lastScoreCrossedBestScore = true //recording that the user has crossed his last best score
                scoreModel.bestScoreBlack = score
            }
            
            // update average score
            var newAvgScore: Float = 0.0
            let newTotalPlay = scoreModel.totalPlayBlack + 1
            newAvgScore = (( scoreModel.avgScoreBlack * Float(scoreModel.totalPlayBlack)) + Float(score.correctAttempts)) / Float(newTotalPlay)
            scoreModel.avgScoreBlack = newAvgScore
            scoreModel.totalPlayBlack = newTotalPlay
            
            // updating whether the user crossed the common average score..
            if score.correctAttempts >= type.commonAverageScore 
                && (scoreModel.blackAvgScoreCrossedAt == nil || scoreModel.blackAvgScoreCrossedAt! == 0) {
                scoreModel.blackAvgScoreCrossedAt = newTotalPlay
            }
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
