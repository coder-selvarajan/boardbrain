//
//  MainView.swift
//  boardbrain
//
//  Created by Selvarajan on 06/05/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
    }
}

#Preview {
    MainView()
}
