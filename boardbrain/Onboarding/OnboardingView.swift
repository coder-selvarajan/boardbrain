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
                Button(selectedIndex > 0 ? "Back" : " ") {
                    withAnimation {
                        selectedIndex -= 1
                    }
                }
                .padding()
            

                Spacer()

                // Skip Button
                Button("Skip") {
                    // Navigate to the Home View
                    hasCompletedOnboarding = true
                }
                .fontWeight(Font.Weight.semibold)
                .padding()
                .frame(width: 100, height: 40)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            TabView(selection: $selectedIndex) {
                OnboardingPage(title: "Welcome to BoardBrain",
                               description: "Master the chess board with our intuitive training modules designed to enhance your skills.",
                               imageName: "logo-smooth-corners",
                               systemImage: false)
                    .tag(0)
                
                OnboardingPage(title: "Learn Chess Coordinates",
                               description: "Improve your board vision with our Coordinates Training. Learn to identify squares quickly and enhance your game analysis skills.",
                               imageName: "square.grid.2x2")
                    .tag(1)
                
                OnboardingPage(title: "Master Chess Moves",
                               description: "Boost your tactical skills with Moves Training. Practice key chess moves and strategies to outplay your opponents.",
                               imageName: "crown")
                               //imageName: "arrow.3.trianglepath")
                    .tag(2)
                
                OnboardingPage(title: "Understand Square Colors",
                               description: "Strengthen your positional understanding with our Square Colors Training. Learn to recognize patterns and control critical squares.",
                               imageName: "square.righthalf.filled")
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
                            Text("Finish")
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
        .background(Color.black.opacity(0.80))
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let imageName: String
    var systemImage: Bool = true
    
    var body: some View {
        VStack {
            Spacer()
            if systemImage {
                Image(systemName: imageName) // Replace 'systemName' with 'imageName' for custom images
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding()
            }
            else {
                Image(imageName) // Replace 'systemName' with 'imageName' for custom images
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
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


//struct OnboardingView: View {
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Hello Chess Lovers!")
//                
//                Button {
//                    //
//                } label: {
//                    Text("Skip")
//                }
//            }
//            Spacer()
//            Text("Board Brain")
//                .font(.title)
//            Spacer()
//            
//            Image(systemName: "crown")
//                .resizable()
//                .frame(width: 100, height: 100)
//            
//            Spacer()
//            
//            Text("Talk about the app")
//            
//            Spacer()
//            
//            Button {
//                //
//            } label: {
//                Text("Next")
//            }
//            .background(.cyan)
//            
//            Spacer()
//        }
//        .foregroundColor(.black)
//        .background(.gray.opacity(0.35))
//    }
//}
//
//#Preview {
//    OnboardingView()
//}
