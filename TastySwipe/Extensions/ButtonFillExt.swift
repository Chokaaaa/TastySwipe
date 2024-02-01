//
//  ButtonFillExt.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 16/01/2024.
//

import Foundation
import SwiftUI

extension View {
    
    func fillButton(_ color : Color) -> some View {
        self
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(color, in: .rect(cornerRadius: 15))
    }
}
