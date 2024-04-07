//
//  BoardViewWithControls.swift
//  boardbrain
//
//  Created by Selvarajan on 07/04/24.
//

import SwiftUI

struct BoardViewWithControls: View {
    @State private var showPiecesPosition = true
    @State private var showRanksandFiles = true
    @State private var showCoordinates = false
    
    var body: some View {
        ScrollView {
            
            Text("BoardBrain")
                .font(.largeTitle)
                .padding()
            
            Toggle("Show Pieces", isOn: $showPiecesPosition)
                .padding(.horizontal)
                .onChange(of: showPiecesPosition, { oldValue, newValue in
                    if newValue {
                        showCoordinates = !newValue
                    }
                })
            
            Toggle("Show Ranks & Files", isOn: $showRanksandFiles)
                .padding(.horizontal)
            
            Toggle("Show Coordinates", isOn: $showCoordinates)
                .padding(.horizontal)
                .padding(.bottom)
                .onChange(of: showCoordinates, { oldValue, newValue in
                    if newValue {
                        showPiecesPosition = !newValue
                    }
                })
            
            BoardView(showPiecesPosition: $showPiecesPosition, showRanksandFiles: $showRanksandFiles, showCoordinates: $showCoordinates, squareClicked: nil)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.95))
        
    }
}

#Preview {
    BoardViewWithControls()
}
