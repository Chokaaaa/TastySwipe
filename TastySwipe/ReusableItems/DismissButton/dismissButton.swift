//
//  dismissButton.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 06/01/2024.
//

import SwiftUI

struct dismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 35, height: 35)
                .shadow(radius: 1.2)
            
            Image(systemName : "xmark")
                .resizable()
                .foregroundStyle(.black)
                .scaledToFit()
                .frame(width: 15, height: 15)
                .clipShape(Circle())
        }
    }
}

#Preview {
    dismissButton()
}
