//
//  GameView.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI

struct GameView: View {
    @State private var showPiecesPosition = true
    @State private var showRanksandFiles = true
    @State private var showCoordinates = false
    
    var body: some View {
        ScrollView {
            
            Text("Board Game")
                .font(.largeTitle)
                .padding()
            
            HStack(alignment: .top) {
                Toggle("Pieces", isOn: $showPiecesPosition)
                    .padding(.horizontal)
                    .onChange(of: showPiecesPosition, { oldValue, newValue in
                        if newValue {
                            showCoordinates = !newValue
                            showRanksandFiles = newValue
                        }
                    })
                
                Toggle("Coordinates", isOn: $showCoordinates)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .onChange(of: showCoordinates, { oldValue, newValue in
                        if newValue {
                            showPiecesPosition = !newValue
                            showRanksandFiles = !newValue
                        }
                    })
                
            }
            //
            //            Toggle("Show Ranks & Files", isOn: $showRanksandFiles)
            //                .padding(.horizontal)
            //
            
            BoardView(showPiecesPosition: $showPiecesPosition,
                      showRanksandFiles: $showRanksandFiles,
                      showCoordinates: $showCoordinates,
                      squareClicked: { value in
                print("Tapped : ", value)
            })
            .padding(.bottom, 20)
            
            Button {
                showCoordinates = false
                showRanksandFiles = false
                showPiecesPosition = false
            } label: {
                Text("Start Game")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.blue)
                    .cornerRadius(10.0)
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.95))
        
    }
}

#Preview {
    GameView()
}
