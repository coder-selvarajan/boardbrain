//
//  ThemeBoard.swift
//  boardbrain
//
//  Created by Selvarajan on 29/04/24.
//

import SwiftUI

struct ThemeBoard: View {
    let lightColor: Color
    let darkColor: Color
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(lightColor)
                    Rectangle()
                        .foregroundColor(darkColor)
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(darkColor)
                    Rectangle()
                        .foregroundColor(lightColor)
                }
            }
//            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/.opacity(0.7),width: 1.0)
        }
//        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
        
    }
}

#Preview {
    ThemeBoard(lightColor: Color.white, darkColor: Color.gray)
}
