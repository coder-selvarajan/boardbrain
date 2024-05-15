//
//  UtilityFunctions.swift
//  boardbrain
//
//  Created by Selvarajan on 11/05/24.
//

import Foundation
import UIKit

func twoDigitFormat(value: Float) -> String {
    return String(format: "%.2f", value)
}

func averageResponseTime(iterationList: [GameIteration]) -> String {
    guard !iterationList.isEmpty else { return "Nil" }
    let totalResponseTime = iterationList.reduce(0.0) { $0 + $1.responseTime }
    let average = totalResponseTime / Double(iterationList.count)
    return String(format: "%.2f", average)
}


func performSoftHapticFeedback() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
    impactFeedback.impactOccurred()
}

func performRigidHapticFeedback() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
    impactFeedback.impactOccurred()
}

func performMediumHapticFeedback() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
}

func performHeavyHapticFeedback() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    impactFeedback.impactOccurred()
}
