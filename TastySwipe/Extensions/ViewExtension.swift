//
//  ViewExtension.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 20/01/2024.
//


import SwiftUI

extension View {
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
}
