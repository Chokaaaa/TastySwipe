//
//  SettingsRowWithPicker.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 07/01/2024.
//

import SwiftUI

struct SettingsRowWithPicker: View {
    
    var imageName: String
    var text: String
    var bgColor : Color
    
    @Environment(\.colorScheme) var current
    @EnvironmentObject var csManager: ColorSchemeManager
    
    @AppStorage("colorScheme") var colorScheme = 0
    
    
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
            
            Text(text)
                .font(.body)
            
            Spacer()
            
            HStack {
                
                Picker("", selection: $csManager.colorScheme) {
                    Text("System").tag(ColorScheme.unspecified)
                    Text("Light").tag(ColorScheme.light)
                    Text("Dark").tag(ColorScheme.dark)
                }
                
            }
            
            
            
            
        }
        
        
    }
}

#Preview() {
    SettingsView()
        .environmentObject(ColorSchemeManager())
}
