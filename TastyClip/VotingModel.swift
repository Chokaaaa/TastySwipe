//
//  VotingModel.swift
//  TastyClip
//
//  Created by Nursultan Yelemessov on 23/01/2024.
//

import Foundation
import FirebaseFirestore

struct VotingModel : Identifiable {
    let id : String
    let title : String
    let location : String
    let image : String
    
    init?(snapshot: DocumentSnapshot ) {
        
        guard let data = snapshot.data() else { return nil }
        guard let title = data["title"] as? String else { return nil }
        guard let location = data["address"] as? String else { return nil }
        guard let image = data["image"] as? String else { return nil }
        self.id = snapshot.documentID
        self.title = title
        self.location = location
        self.image = image
        
    }
    
}
