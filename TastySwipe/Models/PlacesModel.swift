//
//  PlacesModel.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 11/03/2023.
//

import Foundation


struct PlacesModel {
    var title : String
    var image : String
    var category : String
}

var Places = [ PlacesModel(title: "loading", image: "loading", category: "CoffeShop"),
             PlacesModel(title: "McDonalds", image: "McDonalds", category: "Food"),
             PlacesModel(title: "Nusr-Et", image: "NusrEt", category: "Restraunt"),
             PlacesModel(title: "PF.Changs", image: "PF.Changs", category: "Restraunt"),
             PlacesModel(title: "Arabica", image: "Arabica", category: "CoffeShop")
            ]
