//
//  Intro.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 16/01/2024.
//

import Foundation
import SwiftUI


struct Intro : Identifiable {
    
    var id: UUID = .init()
    var text : String
    var textColor : Color
    var emoji : String
    var bgColor : Color
    var circleOffset : CGFloat = 0
    var textOffset : CGFloat = 0
    
}

var sampleIntros: [Intro] = [

    .init(
        text: "Find Coffee",
        textColor: .accentColor,
        emoji: "coffee",
        bgColor: .black
    ),
    
        .init(
            text: "Find Food",
            textColor: .black,
            emoji: "hamburger",
            bgColor: .cyan
        ),
    .init(
        text: "Find Beauty Salon",
        textColor: .cyan,
        emoji: "nail_care",
        bgColor: .indigo
    ),
    .init(
        text: "Find Flowers",
        textColor: .indigo,
        emoji: "tulip",
        bgColor: .accentColor
    ),
    .init(
        text: "Find Coffee",
        textColor: .accentColor,
        emoji: "coffee",
        bgColor: .black
    ),
]
