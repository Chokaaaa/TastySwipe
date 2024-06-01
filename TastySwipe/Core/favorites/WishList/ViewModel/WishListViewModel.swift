//
//  WishListViewModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/01/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class WishListViewModel : ObservableObject {
    
    @Published var wishList: [WishListModel] = []
    var listner: ListenerRegistration?
    
    init() {
        createWishListObserver()
    }
    
    func removeWishListObserver() {
        listner?.remove()
    }
    
    
    func createWishListObserver() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        listner = Firestore.firestore().collection("users").document(currentUserId).collection("wishlist").addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            self.wishList = snapshot.documents.compactMap { WishListModel(snapshot: $0) }
        }
        
    }
    
}
