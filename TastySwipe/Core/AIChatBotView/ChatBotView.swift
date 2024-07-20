//
//  ChatBotView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 20/07/2024.
//

import SwiftUI

struct ChatBotView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChatBotView()
}
