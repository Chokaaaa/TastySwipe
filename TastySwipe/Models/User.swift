//
//  User.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 24/04/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User : Codable {
    var fullName : String
    var email : String
    var uid : String
    var avatar: URL?
    
    init(fullName: String, email: String, uid: String) {
        
        self.fullName = fullName
        self.email = email
        self.uid = uid
        
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else { return nil }
        guard let fullName = data["fullName"] as? String else { return nil}
        guard let email = data["email"] as? String else { return nil}
        self.fullName = fullName
        self.email = email
        self.uid = snapshot.documentID
        if let avatar = data["avatar"] as? String,
           let avatarURL = URL(string: avatar) {
            self.avatar = avatarURL
        }
    }
    
}

extension User: Equatable {
    
}
