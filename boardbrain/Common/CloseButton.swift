//
//  CloseButton.swift
//  boardbrain
//
//  Created by Selvarajan on 11/05/24.
//

import SwiftUI

struct CloseButton: View {
    var closeButtonClicked : () -> Void
    
    var body: some View {
        Button {
            closeButtonClicked()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red.opacity(0.8))
        }
        .padding([.top, .trailing], 10)
    }
}

//#Preview {
//    CloseButton()
//}
