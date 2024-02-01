//
//  CirlceButtonModifier.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 05/01/2024.
//

import Foundation
import SwiftUI

struct CirlceButtonModifier : ViewModifier {
    
    let width : CGFloat
    let height : CGFloat
    let cornerRadius : CGFloat
    
    func body(content : Content) -> some View {
        content
            .frame(width: width, height: height)
            .background(.white)
            .cornerRadius(cornerRadius)
            .shadow(color: .gray.opacity(0.5), radius: 5,x: 0,y: 0)
    }
}
