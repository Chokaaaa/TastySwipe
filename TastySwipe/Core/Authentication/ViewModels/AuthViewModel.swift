//
//  AuthViewModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 24/04/2023.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    func signIn(withEmail email: String, password: String, completion: @escaping (User?) -> Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let result = result else {
                completion(nil)
                return
            }
            Firestore.firestore().collection("users").document(result.user.uid).getDocument { snapshot, error in
                if let error = error {
                    completion(nil)
                    return
                }
                guard let snapshot = snapshot else {
                    completion(nil)
                    return
                }
                guard let user = User(snapshot: snapshot) else  {
                    completion(nil)
                    return
                }
                completion(user)
            }
        }
    }
    
    func registerUser(withEmail email: String, password: String, fullName: String, completion : @escaping (User?) -> Void ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(nil)
                print("DEBUG: Failed to sign up user with error \(error.localizedDescription)")
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(nil)
                return
            }
            
            
            let user = User(fullName: fullName, uid: firebaseUser.uid, email: email, phoneNumber: nil)
            
            do {
                let encodedUser = try Firestore.Encoder().encode(user)
                Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
                completion(user)
            } catch {
                completion(nil)
            }
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
//    func fetchUser() {
//        guard let uid = self.userSession?.uid else {return}
//        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
//            guard let snapshot = snapshot else {return}
//            
//            guard let user = try? snapshot.data(as: User.self) else {return}
//            
//            print("DEBUG: User is \(user.fullName)")
//            print("DEBUG: User is \(user.email)")
//        }
//    }
    
}

//MARK: - Sign in with SSO
extension AuthViewModel {
    
}


//MARK: - Sign in with SSO
extension AuthViewModel {
    
}
