//
//  WishListModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/01/2024.
//

import Foundation
import FirebaseFirestore

struct WishListModel : Identifiable {
    let title : String
    let location : String
    let image : String
    let category : String
    let rating : Double
    let id : String
    
    init(title: String, location: String, image: String, category: String, rating: Double, id: String) {
        self.title = title
        self.location = location
        self.image = image
        self.category = category
        self.rating = rating
        self.id = id
    }
    
    init?(snapshot : QueryDocumentSnapshot) {
        
        let data = snapshot.data()
        
        guard let title = data["title"] as? String else { return nil}
        guard let location = data["location"] as? String else { return nil}
        guard let image = data["image"] as? String else { return nil}
        guard let category = data["category"] as? String else { return nil}
        guard let rating = data["rating"] as? Double else { return nil}
        guard let id = data["id"] as? String else { return nil}
        
        self.title = title
        self.location = location
        self.image = image
        self.category = category
        self.rating = rating
        self.id = id
        
    }
    
}

extension WishListModel: Hashable, Equatable {
    
}
