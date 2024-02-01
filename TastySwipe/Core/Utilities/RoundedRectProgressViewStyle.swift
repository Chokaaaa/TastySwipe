//
//  RoundedRectProgressViewStyle.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 20/01/2024.
//

import Foundation
import SwiftUI

struct RoundedRectProgressViewStyle: ProgressViewStyle {
   func makeBody(configuration: Configuration) -> some View {
       ZStack(alignment: .leading) {
           RoundedRectangle(cornerRadius: 14)
               .frame(width: 250, height: 14)
               .foregroundColor(.blue)
               .overlay(Color.black.opacity(0.5)).cornerRadius(14)
           
           RoundedRectangle(cornerRadius: 14)
               .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 250, height: 14)
               .foregroundColor(.yellow)
       }
       .padding()
   }
}
