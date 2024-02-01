//
//  InfiniteScroller.swift
//  MyTradingJournal
//
//  Created by James Sedlacek on 11/22/22.
//

import SwiftUI

struct InfiniteScroller<Content: View>: View {
    
    enum Direction {
        case forward
        case backward
    }
    
    let contentWidth: CGFloat
    let contentHeight: CGFloat
    let direction: Direction
    var content: (() -> Content)
    @State private var xOffset: CGFloat = 0
    @State private var yOffset : CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(0..<10) {_ in 
                        content()
                    }
                }
                .offset(x: 0, y: yOffset)
        }
        .disabled(true)
        .onAppear {
            yOffset = direction == .forward ? 0 : -contentHeight
            withAnimation(.linear(duration: 20).repeatForever()) {
                yOffset = direction == .forward ? -contentHeight : 0
            }
            
        }
    }
}
