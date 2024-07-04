//
//  AnalyticsManager.swift
//  boardbrain
//
//  Created by Selvarajan on 02/07/24.
//

import UIKit
import SwiftUI
import TelemetryDeck
//import FirebaseAnalytics

struct cAccessibilityElement {
    var label: String
    var identifier: String
    var frame: CGRect
    var trait: String
}

func sendClickEvent(element: cAccessibilityElement) {
//    Analytics.logEvent("click_event", parameters: ["app": "BoardBrain",
//                                                   "colorTheme": "dark mode",
//                                                   "event": "click",
//                                                   "identifier":element.identifier,
//                                                   "label":element.label,
//                                                   "control_type":element.trait,
//                                                   "value":element.label])
    
    TelemetryDeck.signal(
        "\(element.trait)(\(element.label)) - Click Event",
        parameters: [
            "app": "BoardBrain",
            "event": "click",
            "identifier":element.identifier,
            "value":element.label,
            "control_type":element.trait
        ]
    )
}

extension UIApplication {
    
    @objc dynamic func newSendEvent(_ event: UIEvent) {
        newSendEvent(event)
        
        let start = Date() //capturing start date to measure performance
        var cElements: [cAccessibilityElement] = []
        var touchViewFrame: CGRect = CGRectNull
        
        if (event.allTouches != nil){
            let touches: Set<UITouch> = event.allTouches!
            let touch: UITouch = touches.first!
            if touch.phase != .began { return }
            
            if let tView = touch.view {
                // tView is probably the CGDrawingView here
                
                // Capture the touch location and frame info
                touchViewFrame = tView.convert(tView.bounds, to: nil)
                let touchLocation = touch.location(in: touch.window)
                
                // Extract all the accessibility elements from the current scene
                cElements = getAllAccessibilityElements() ?? []
                
                //Match the view with accessibility elements
                /*
                    Frame Matching Approaches:
                        1. Frame-to-frame match with 10 points tolerance
                        2. Frame-contains-frame matching
                        3. Touch location falls within a frame
                */
                // 1..
                if let target = matchFrame(touchViewFrame,
                                           withAccessibilityElements: cElements) {
                    sendClickEvent(element: target) //Call to TelemetryDeck
                    printEvent(startTime: start, element: target, approachIndex: 1)
                } else {
                    // 2..
                    let elementsContainingTouchView = cElements.filter { $0.frame.contains(touchViewFrame) }
                    if elementsContainingTouchView.count > 0 {
                        for element in elementsContainingTouchView {
                            sendClickEvent(element: element) //Call to TelemetryDeck
                            printEvent(startTime: start, element: element, approachIndex: 2)
                        }
                    } else if let target = findElementByTouchLocation(for: touchLocation,
                                                                      withAccessibilityElements: cElements) {
                        // 3.. touch location falls within any of the accessibility elements?
                        if target.label != "" {
                            sendClickEvent(element: target) //Call to TelemetryDeck
                            printEvent(startTime: start, element: target, approachIndex: 3)
                        }
                    }
                }
                
            }
        }
    } //celebrusSendEvent
} //UIApplication extension

func printEvent(startTime: Date, element: cAccessibilityElement, approachIndex: Int) {
    if element.label == "" {
        return
    }
    // measure the performance
    let end = Date()
    let executionTime = end.timeIntervalSince(startTime)
    let formattedExecutionTime = String(format: "%.3f", executionTime)
    
    print("\(formattedExecutionTime) sec : \(element.trait) ( \(element.identifier) - \(element.label) ) is clicked.")
    print("---------------------------------------------------------------------------\(approachIndex)")
}

// Helper methods
func extractAccessibilityLabel(_ object: AnyObject) -> String {
    if object.responds(to: #selector(UIAccessibilityElement.accessibilityLabel)) {
        if let result = object.perform(#selector(UIAccessibilityElement.accessibilityLabel))?.takeUnretainedValue() as? String {
            return result
        }
    }
    return ""
}

func extractAccessibilityIdentifier(_ object: AnyObject) -> String {
    if object.responds(to: #selector(getter: UIAccessibilityElement.accessibilityIdentifier)) {
        if let result = object.perform(#selector(getter: UIAccessibilityElement.accessibilityIdentifier))?.takeUnretainedValue() as? String {
            return result
        }
    }
    return ""
}

func extractAccessibilityFrame(_ object: AnyObject) -> CGRect {
    if object.responds(to: NSSelectorFromString("accessibilityFrame")) {
        if let accessibilityFrameValue = object.value(forKey:  "accessibilityFrame") as? CGRect {
            return accessibilityFrameValue
        }
    }
    
    return CGRect.null
}

func extractAccessibilityTrait(_ object: AnyObject) -> String {
    if object.responds(to: #selector(UIAccessibilityElement.accessibilityTraits)) {
        if let result = object.accessibilityTraits {
            if result.rawValue == 1 {
                return "Button"
            } else if result.rawValue == 4 {
                return "Image"
            } else if result.rawValue == 64 {
                return "Header"
            } else if result.rawValue == 1024 {
                return "StaticText"
            } else if result.rawValue == 2 {
                return "Link"
            } else {
                return "unknown - \(result.rawValue)"
            }
        }
    }
    return ""
}

func matchFrame(_ touchedFrame: CGRect, withAccessibilityElements elements: [cAccessibilityElement]) -> cAccessibilityElement? {
    let tolerance: CGFloat = 10.0
    for element in elements {
        let elementFrame = element.frame
        if framesMatch(touchedFrame, elementFrame, tolerance: tolerance) {
            return element
        }
    }
    return nil
}

private func framesMatch(_ frame1: CGRect, _ frame2: CGRect, tolerance: CGFloat) -> Bool {
    let xMatch = abs(frame1.origin.x - frame2.origin.x) <= tolerance
    let yMatch = abs(frame1.origin.y - frame2.origin.y) <= tolerance
    let widthMatch = abs(frame1.size.width - frame2.size.width) <= tolerance
    let heightMatch = abs(frame1.size.height - frame2.size.height) <= tolerance
    
    return xMatch && yMatch && widthMatch && heightMatch
}

func findElementByTouchLocation(for location: CGPoint, withAccessibilityElements elements: [cAccessibilityElement]) -> cAccessibilityElement? {
    for element in elements {
        if element.frame.contains(location) {
            return element
        }
    }
    
    return nil
}


// Extracting all the accessibility elements from the current Scene
func getAllAccessibilityElements() -> [cAccessibilityElement]? {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {
        return nil
    }
    return findAccessibilityElements(in: window)
}

func findAccessibilityElements(in view: UIView) -> [cAccessibilityElement] {
    var cElements: [cAccessibilityElement] = []

    if let accessibilityElements = view.accessibilityElements {
        for element in accessibilityElements {
            let aeObject = element as AnyObject
            cElements.append(
                cAccessibilityElement(label: extractAccessibilityLabel(aeObject),
                                      identifier: extractAccessibilityLabel(aeObject),
                                      frame: extractAccessibilityFrame(aeObject),
                                      trait: extractAccessibilityTrait(aeObject)))
        }
    }

    for subview in view.subviews {
        cElements.append(contentsOf: findAccessibilityElements(in: subview))
    }

    return cElements
}
