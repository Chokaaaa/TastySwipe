//
//  SettingsRow.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI

struct SettingsRow: View {
    let title: String
    let imageName: String
    let bgColor : Color
    var body: some View {
        HStack(spacing: 25) {
            ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(bgColor)
                        
                        HStack(spacing: 15) {
                            Image(systemName: imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                            
                          
                        }
                        .padding(5)
                    }
            .frame(width: 15, height: 10)
            
            Text(title)
                .font(.body)
        }
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
