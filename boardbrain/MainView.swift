//
//  MainView.swift
//  boardbrain
//
//  Created by Selvarajan on 06/05/24.
//

import SwiftUI
import StoreKit

struct MainView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("launchCount") var launchCount: Int = 0
    
    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .onAppear(){
            //            hasCompletedOnboarding = false
        }
        .onAppear {
            launchCount += 1  // Incrementing the launch count
            checkAndPromptForReview()
        }
    }
    
    private func checkAndPromptForReview() {
        if launchCount == 5 {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}

#Preview {
    MainView()
}
