//
//  OnboardingView.swift
//  boardbrain
//
//  Created by Selvarajan on 06/05/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    
    @State private var selectedIndex = 0
    private let totalPages = 3

    var body: some View {
        VStack {
            // Navigation Buttons at the Top
            HStack {
                // Back Button
                
                Button(selectedIndex > 0 ? " ← Back" : " ") {
                    withAnimation {
                        selectedIndex -= 1
                    }
                }
                .padding()
            

                Spacer()

                // Skip Button
                Button(selectedIndex < 3 ? "Skip": "Close") {
                    // Navigate to the Home View
                    hasCompletedOnboarding = true
                }
                .font(Font.headline.weight(.semibold))
//                .fontWeight(Font.Weight.semibold)
                .padding()
                .frame(width: 100, height: 40)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            TabView(selection: $selectedIndex) {
                OnboardingPage(title: "Welcome to BoardBrain",
                               description: "Master the chessboard with intuitive training modules designed to enhance your skills.",
                               imageName: "logo-smooth-corners",
                               systemImage: false)
                    .tag(0)
                
                OnboardingPage(title: "Learn Coordinates",
                               description: "Learn and practice identifying the correct coordinates on the chessboard to improve your board vision.",
                               imageName: "square.grid.2x2")
                    .tag(1)
                
                OnboardingPage(title: "Master Chess Moves",
                               description: "Explore various piece movements in an interactive format to boost your tactical skills.",
                               imageName: "crown")
                               //imageName: "arrow.3.trianglepath")
                    .tag(2)
                
                OnboardingPage(title: "Recognize Colors",
                               description: "Enhance your ability to quickly recognize the colors of different squares on the chessboard, a vital skill for strategic planning.",
                               imageName: "square.lefthalf.filled")
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            .padding()

            // Next and Finish Buttons
            HStack {
                Spacer()
                if selectedIndex < totalPages {
                    Button(action: {
                        withAnimation {
                            selectedIndex += 1
                        }
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Next")
                                .fontWeight(Font.Weight.semibold)
                            Spacer()
                        }
                    })
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                } else {
                    Button(action: {
                        hasCompletedOnboarding = true
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Get started")
                                .fontWeight(Font.Weight.semibold)
                            Spacer()
                        }
                    })
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                }
            }.padding()
            
        }
        .foregroundColor(.white)
        .background(Color.white.opacity(0.20))
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let imageName: String
    var systemImage: Bool = true
    let imageWidth: CGFloat = UIScreen.main.bounds.size.height * 0.125
    let iconWidth: CGFloat = UIScreen.main.bounds.size.height * 0.1
    
    var body: some View {
        VStack {
            Spacer()
            if systemImage {
                Image(systemName: imageName) // Replace 'systemName' with 'imageName' for custom images
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconWidth)
                    .padding()
            }
            else {
                Image(imageName) // Replace 'systemName' with 'imageName' for custom images
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth)
                    .padding()
            }
            Spacer()
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text(description)
                .font(.body)
                .padding()
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(hasCompletedOnboarding: .constant(false))
            .colorScheme(ColorScheme.dark)
    }
}
