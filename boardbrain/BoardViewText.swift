//
//  BoardView.swift
//  boardbrain
//
//  Created by Selvarajan on 06/04/24.
//

import SwiftUI

struct BoardViewText: View {
private let rows = 8
    private let columns = 8
    
    // Generate the grid layout with no spacing
    private var gridLayout: [GridItem] {
        Array(repeating: .init(.flexible(), spacing: 0), count: columns)
    }
    
    private func coordinate(forIndex index: Int) -> String {
        let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let file = files[index % columns]
        let rank = 8 - index / columns
        return "\(file)\(rank)"
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 0) {
                ForEach(0..<(rows * columns), id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .foregroundColor((index / columns) % 2 == index % 2 ? Color(hex: "#F0D9B5") : Color(hex: "#B58863"))
                        
                        Text(coordinate(forIndex: index))
                            .foregroundColor((index / columns) % 2 == index % 2 ? .black : .white)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray)
    }
}

#Preview {
    BoardViewText()
}
