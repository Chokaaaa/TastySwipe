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
    var email : String?
    var phoneNumber: String?
    var uid : String
    var avatar: URL?
    
    
    init(fullName: String, uid: String, email: String?, phoneNumber: String?) {
        
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.uid = uid
        
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else { return nil }
        guard let fullName = data["fullName"] as? String else { return nil}
        self.fullName = fullName
        self.uid = snapshot.documentID
        if let avatar = data["avatar"] as? String,
           let avatarURL = URL(string: avatar) {
            self.avatar = avatarURL
        }
        if let email = data["email"] as? String {
            self.email = email
        }
        
        if let phoneNumber = data["phoneNumber"] as? String {
            self.phoneNumber = phoneNumber
        }
        
    }
    
}

extension User: Equatable {
    
}
