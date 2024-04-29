//
//  ColorsPopupOptions.swift
//  boardbrain
//
//  Created by Selvarajan on 28/04/24.
//

import SwiftUI

struct ColorsPopupOptions: View {
    // Binding variables to pass state between views
    @Binding var showCoordinates: Bool
    @Binding var whiteSide: Bool
    
    var body: some View {
        VStack {
            Text("Board Options")
                .font(.title2)
                .padding(.bottom)
            Divider()
                .background(.white.opacity(0.80))
                .padding(.bottom)
                
            
            Toggle("Show Coordinates", isOn: $showCoordinates)
                .font(.title2)
                .padding()
            
            HStack(alignment: .center) {
                Text("Board Side")
                    .font(.title2)
                    .padding(.leading)
                
                Spacer()
                
                HStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(whiteSide ? .green : .gray)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedCorner(radius: 5, corners: [.topLeft, .bottomLeft]))
                            .padding(0)
                        
                        
                        Image("king-w")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                whiteSide = !whiteSide
                            }
                    }.onTapGesture {
                        whiteSide = !whiteSide
                    }
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(!whiteSide ? .green : .gray)
                            .frame(width: 50, height:50)
                            .clipShape(RoundedCorner(radius: 5, corners: [.topRight, .bottomRight]))
                            .padding(0)
                        
                        Image("king-b")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                whiteSide = !whiteSide
                            }
                    }
                    .onTapGesture {
                        whiteSide = !whiteSide
                    }
                } // HStack
                .padding(.top)
                .padding(.trailing)
            } // HStack
            
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .background(.black.opacity(0.95))
    }
}

#Preview {
    ColorsPopupOptions(showCoordinates: .constant(true), whiteSide: .constant(true))
}
