//
//  HomeView.swift
//  boardbrain
//
//  Created by Selvarajan on 16/04/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CoordinateTrainingView()) {
                    HStack {
                        Image(systemName: "1.circle.fill")
                            .font(.title)
                        Text("Coordinates Training")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                
                NavigationLink(destination: ColorsTrainingView()) {
                    HStack {
                        Image(systemName: "2.circle.fill")
                            .font(.title)
                        Text("Square Colors Training")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                
                NavigationLink(destination: ChessboardView()) {
                    HStack {
                        Image(systemName: "3.circle.fill")
                            .font(.title)
                        Text("Moves Training")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Board Brain")
            .toolbar {
                // Hamburger menu icon on the left
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Introduction", action: {})
                        Button("Game: Coordinates", action: {})
                        Button("Game: Moves", action: {})
                        Button("Game: Light/Dark", action: {})
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.white)
                    }
                }
                
                // Gear icon on the right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for the gear icon
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
