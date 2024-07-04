//
//  StarType.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/07/2024.
//

import Foundation
import SwiftUI

enum StarType {
    case fullStar, halfStar, emptyStar
    var starImage: Image {
        switch self {
        case .fullStar:
            return Image("fullStar")
        case .halfStar:
            return Image("halfStar")
        case .emptyStar:
            return Image("emptyStar")
        }
    }
    
    static func getStarImage(value: Double, index: Int) -> Image {
        let rounded = round(value * 2) / 2.0
        if index <= Int(rounded) {
            return StarType.fullStar.starImage
        }
        if Double(index) - 0.5 == rounded {
            return StarType.halfStar.starImage
        }
        return StarType.emptyStar.starImage
    }
    
}


