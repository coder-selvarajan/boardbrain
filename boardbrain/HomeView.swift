//
//  HomeView.swift
//  boardbrain
//
//  Created by Selvarajan on 16/04/24.
//

import SwiftUI

struct HomeView: View {
    let buttonHeight: CGFloat = UIScreen.main.bounds.size.height * 0.085
    let logoSize: CGFloat = UIScreen.main.bounds.size.height * 0.045
    
    var body: some View {
//        NavigationStack {
            VStack {
                Spacer()
                
                NavigationLink(destination: CoordinateTrainingHome()) {
                    HStack(alignment: .center) {
                        Image(systemName: "square.grid.2x2.fill") // "textformat.123")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30, alignment: .center)
                            .foregroundColor(.blue)
                            .padding(.trailing, 10)
                            .padding(.leading, 5)
                        VStack(alignment: .leading) {
                            Text("Coordinates Training")
                                .font(.headline)
                            Text("Practice identifying coordinates")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }.padding(0)
                        Spacer()
                        Image(systemName: "chevron.compact.right") // "textformat.123")
//                            .font(.headline)
                            .resizable()
                            .frame(width: 5, height: 10, alignment: .center)
                            .foregroundColor(.black.opacity(0.80))
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: buttonHeight)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
                
                
                NavigationLink(destination: MovesTrainingHome()) {
                    HStack(alignment: .center) {
                        Image(systemName: "crown.fill")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30, alignment: .center)
                        //                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .padding(.trailing, 10)
                            .padding(.leading, 5)
                        VStack(alignment: .leading) {
                            Text("Moves Training")
                                .font(.headline)
                            Text("Enhance board vision")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        Image(systemName: "chevron.compact.right") // "textformat.123")
//                            .font(.headline)
                            .resizable()
                            .frame(width: 5, height: 10, alignment: .center)
                            .foregroundColor(.black.opacity(0.80))
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: buttonHeight)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                NavigationLink(destination: ColorsTrainingHome()) {
                    HStack(alignment: .center) {
                        Image(systemName: "square.lefthalf.filled")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30, alignment: .center)
                            .foregroundColor(.yellow)
                            .padding(.trailing, 10)
                            .padding(.leading, 5)
                        VStack(alignment: .leading) {
                            Text("Colors Training")
                                .font(.headline)
                            Text("Recognize squares better")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        Image(systemName: "chevron.compact.right") // "textformat.123")
//                            .font(.headline)
                            .resizable()
                            .frame(width: 5, height: 10, alignment: .center)
                            .foregroundColor(.black.opacity(0.80))
                    }
                    .padding()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: buttonHeight)
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
                    .frame(maxWidth: UIScreen.main.bounds.size.width - 60,
                           maxHeight:  UIScreen.main.bounds.size.width - 60)
                    .padding(.horizontal, 30)
                }
                //                .frame(width: 200, height: 200)
                
                Spacer()
            } // VStack
//            .navigationPopGestureDisabled(false)
            .background(Color.white.opacity(0.20))
            //            .navigationTitle("Board Brain")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image("logo-smooth-corners")
                            .resizable()
                            .frame(width: logoSize, height: logoSize)
                        //                            .padding(.leading, 10)
                        Text("Board Brain").font(.title3)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 10)
                        Spacer()
                    }
                } //ToolbarItem
                // Gear icon on the right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationLink(destination: SettingsView()) {
                            Label("Settings", systemImage: "gearshape")
                        }
                        NavigationLink(destination: AboutView()) {
                            Label("About", systemImage: "info")
                        }
                        
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.white)
                    }
                } //ToolbarItem
            } // toolbar
//        } // NavigationStack
    }
}

#Preview {
    HomeView()
        .colorScheme(ColorScheme.dark)
}
