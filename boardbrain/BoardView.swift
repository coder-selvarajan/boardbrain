//
//  BoardView.swift
//  boardbrain
//
//  Created by Selvarajan on 06/04/24.
//

import SwiftUI

struct BoardView: View {
    let rows: Int = 8
        let columns: Int = 8
        @State private var showRanksFiles = true // State to toggle ranks and files
        
        // Generate the grid layout with no spacing
        var gridLayout: [GridItem] {
            Array(repeating: .init(.flexible(), spacing: 0), count: columns)
        }
        
        var body: some View {
            VStack {
                Toggle("Show Ranks & Files", isOn: $showRanksFiles)
                    .padding()
                
                // Grid to hold ranks and files labels if toggled on
                if showRanksFiles {
                    HStack(spacing: 0) {
                        Text(" ")
                            .frame(width: 20) // Placeholder for rank labels
                        
                        ForEach(["a", "b", "c", "d", "e", "f", "g", "h"], id: \.self) { file in
                            Text(file.uppercased())
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                HStack(spacing: 0) {
                    if showRanksFiles {
                        VStack(spacing: 0) {
                            ForEach((1...rows).reversed(), id: \.self) { rank in
                                Text("\(rank)")
                                    .frame(height: 20) // Adjust to match square size
                                    .rotationEffect(.degrees(-90))
                            }
                        }
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: gridLayout, spacing: 0) {
                            ForEach(0..<(rows * columns), id: \.self) { index in
                                Rectangle()
                                    .foregroundColor((index / columns) % 2 == index % 2 ? Color(hex: "#F0D9B5") : Color(hex: "#B58863"))
                                    .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray)
                }
            }
        }
    
}

#Preview {
    BoardView()
}
