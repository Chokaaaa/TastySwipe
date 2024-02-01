//
//  VoteModel.swift
//  TastyClip
//
//  Created by Nursultan Yelemessov on 28/01/2024.
//

import Foundation
import Firebase

struct VoteModel : Identifiable {
    let id: String
    let name: String
    let vote: Bool
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        guard let name = data["name"] as? String else { return nil }
        guard let vote = data["vote"] as? Bool else { return nil }
        self.id = snapshot.documentID
        self.name = name
        self.vote = vote
    }
    
}
