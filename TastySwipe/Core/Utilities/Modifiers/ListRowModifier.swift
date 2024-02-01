//
//  ListRowModifier.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 06/01/2024.
//

import Foundation
import SwiftUI

struct ListRowModifier : ViewModifier {
    
    func body(content : Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 30, leading: 15, bottom: 20, trailing: 16))
    }
}
