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
                Spacer()
                
                NavigationLink(destination: CoordinateTrainingView()) {
                    HStack(alignment: .top) {
                        Image(systemName: "square.grid.2x2.fill") // "textformat.123")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 20)
                        VStack(alignment: .leading) {
                            Text("Coordinates")
                                .font(.title2)
                            Text("Training")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                
                
                NavigationLink(destination: ChessboardView()) {
                    HStack(alignment: .top) {
                        Image(systemName: "crown.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding(.horizontal, 15)
                        VStack(alignment: .leading) {
                            Text("Piece Moves")
                                .font(.title2)
                            Text("Training")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: ColorsTrainingView()) {
                    HStack(alignment: .top) {
                        Image(systemName: "square.righthalf.filled")
                            .font(.largeTitle)
                            .foregroundColor(.orange.opacity(0.95))
                            .padding(.horizontal, 20)
                        VStack(alignment: .leading) {
                            Text("Square Colors")
                                .font(.title2)
                            Text("Training")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                
                Spacer()
                
                BoardView(showPiecesPosition: .constant(true), showRanksandFiles: .constant(false), showCoordinates: .constant(true), whiteSide: .constant(true), targetIndex: .constant(-1), gameStarted: .constant(false), squareClicked: { value in
                    print(value)
                })
                .padding(.horizontal, 30)
//                .frame(width: 200, height: 200)
                
                Spacer()
            }
            .background(Color.white.opacity(0.20))
            .navigationTitle("Board Brain")
            .navigationBarTitleDisplayMode(.inline)
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
        .colorScheme(ColorScheme.dark)
}
