//
//  Coordinate.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import Foundation

struct Square {
    let rank: Int
    let file: String
    let index: Int
    
    func getCoordinate() -> String {
        return "\(file)\(rank)"
    }
}
