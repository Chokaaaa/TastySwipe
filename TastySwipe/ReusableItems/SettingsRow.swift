//
//  SettingsRow.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI

struct SettingsRow: View {
    var image: String
    var text: String
    var body: some View {
        HStack(spacing: 12) {
                Image(image)
                .imageScale(.medium)
                .font(.title)
            
            Text(text)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .font(.title2)
                .foregroundColor(.gray)
            
            
        }
        .padding([.leading,.trailing], 20)
        .padding([.bottom,.top],7.5)
    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
//        SettingsRow(image: "settingsProfile", text: "Profile")
        SettingsView()
    }
}
