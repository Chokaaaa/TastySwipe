//
//  PreferedPlaceModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 07/01/2024.
//

import Foundation
import SwiftData

@Model class PreferedPlaceModel  {
    
    var place : TagModel
    
    init(place: TagModel) {
        self.place = place
    }
    
}
