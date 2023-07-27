//
//  PageIndicator.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 21/04/2023.
//

import SwiftUI

struct PageIndicator: View {
    var currentIndex: Int
    var pageCount: Int
    
    var body: some View {
        HStack {
            ForEach(0..<pageCount) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(currentIndex == index ? Color.accentColor : Color.gray.opacity(0.5))
            }
        }
    }
}
