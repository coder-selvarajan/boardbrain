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
                
                NavigationLink(destination: CoordinateTrainingHome()) {
                    HStack(alignment: .center) {
                        Image(systemName: "square.grid.2x2.fill") // "textformat.123")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .center)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 15)
                        VStack(alignment: .leading) {
                            Text("Coordinates")
                                .font(.title3)
                            Text("Training")
                                .font(.subheadline)
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
                
                
                NavigationLink(destination: MovesTrainingHome()) {
                    HStack(alignment: .center) {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .center)
//                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding(.horizontal, 15)
                        VStack(alignment: .leading) {
                            Text("Moves")
                                .font(.title3)
                            Text("Training")
                                .font(.subheadline)
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
                
                NavigationLink(destination: ColorsTrainingHome()) {
                    HStack(alignment: .center) {
                        Image(systemName: "square.righthalf.filled")
                            .resizable()
                            .frame(width: 35, height: 35, alignment: .center)
                            .foregroundColor(.orange.opacity(0.95))
                            .padding(.horizontal, 15)
                        VStack(alignment: .leading) {
                            Text("Colors")
                                .font(.title3)
                            Text("Training")
                                .font(.subheadline)
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
                
                VStack{
                    Text("Sample Board with Pieces & Coordinates:")
                        .font(.footnote)
                    BoardView(showPiecesPosition: .constant(true), showRanksandFiles: .constant(false), showCoordinates: .constant(true), whiteSide: .constant(true), targetIndex: .constant(-1), gameStarted: .constant(false), squareClicked: { value in
                        print(value)
                    })
                    .padding(.horizontal, 30)
                }
//                .frame(width: 200, height: 200)
                
                Spacer()
            }
            .background(Color.white.opacity(0.20))
//            .navigationTitle("Board Brain")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Board Brain").font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                }
                // Hamburger menu icon on the left
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Button("Introduction", action: {})
//                        Button("Game: Coordinates", action: {})
//                        Button("Game: Moves", action: {})
//                        Button("Game: Light/Dark", action: {})
//                    } label: {
//                        Image(systemName: "line.horizontal.3")
//                            .foregroundColor(.white)
//                    }
//                }
                
                // Gear icon on the right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Settings", action: {})
                        Button("About", action: {})
                    } label: {
                        Image(systemName: "gearshape.fill")
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
