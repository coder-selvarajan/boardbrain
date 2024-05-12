//
//  UtilityFunctions.swift
//  boardbrain
//
//  Created by Selvarajan on 11/05/24.
//

import Foundation

func twoDigitFormat(value: Float) -> String {
    return String(format: "%.2f", value)
}

func averageResponseTime(iterationList: [GameIteration]) -> String {
    guard !iterationList.isEmpty else { return "Nil" }
    let totalResponseTime = iterationList.reduce(0.0) { $0 + $1.responseTime }
    let average = totalResponseTime / Double(iterationList.count)
    return String(format: "%.2f", average)
}
