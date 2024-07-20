//
//  SessionManager.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 08/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import SwiftUI
import CryptoKit
import AuthenticationServices


class SessionManager : NSObject, ObservableObject {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    @Published var currentUser: User?
    @Published var appleSignInCompleted = false
    fileprivate var currentNonce: String?
    var appleLoginCompletionHandler: ((_ success: Bool) -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    override init() {
        super.init()
        if let userId = Auth.auth().currentUser?.uid {
            fetchLoggedIn(userId: userId)
        }
    }
    
    func observeAuth() {
        Auth.auth().addStateDidChangeListener { _, _ in
            if let user = Auth.auth().currentUser {
                self.fetchLoggedIn(userId: user.uid)
            }
        }
    }
    
    func fetchLoggedIn(userId: String) {
        Firestore.firestore().collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            guard let user = User(snapshot: snapshot) else  {
                return
            }
            self.currentUser = user
        }
    }
    
    func googleSignIn(completion: @escaping (Bool) -> Void) {
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    self.authenticateUser(for: user, with: error, completion: completion)
                }
            } else {
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                let configuration = GIDConfiguration(clientID: clientID)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
                GIDSignIn.sharedInstance.configuration = configuration
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {result, error in
                    self.authenticateUser(for: result?.user, with: error, completion: completion)
                }
            }
        }
    
    func authenticateUser(for user: GIDGoogleUser?, with error: Error?, completion: @escaping (Bool) -> Void) {
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else {
            completion(false)
            return
        }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                guard let user = result?.user else { 
                    completion(false)
                    return
                }
                guard let fullName = user.displayName else {
                    completion(false)
                    return
                }
                guard let email = user.email else {
                    completion(false)
                    return
                }
                let userInfo: [String : Any] = [
                    "fullName": fullName,
                    "email": email
                ]
                Firestore.firestore().collection("users").document(user.uid).setData(userInfo)
                let userProfile = User(fullName: fullName, uid: user.uid, email: email, phoneNumber: nil)
                self.currentUser = userProfile
                self.isOnboarding = false
                completion(true)
            }

    }
    
    func startSignInWithAppleFlow(appleLoginCompletionHandler: @escaping (_ success: Bool) -> Void) {
        self.appleLoginCompletionHandler = appleLoginCompletionHandler
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)
        
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
        
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    
}


extension SessionManager: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential, including the user's full name.
      let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
              print(error.localizedDescription)
              return
          }
          
          guard let user = authResult?.user else { return }
          guard let fullName = user.displayName else { return }
          guard let email = user.email else { return }
          
          let userInfo: [String : Any] = [
              "fullName": fullName,
              "email": email
          ]
          Firestore.firestore().collection("users").document(user.uid).setData(userInfo) { error in
              if let error = error {
                  print("Error for apple \(error.localizedDescription)")
                  return
              }
              let userProfile = User(fullName: fullName, uid: user.uid, email: email, phoneNumber: nil)
              
              self.currentUser = userProfile
              self.isOnboarding = false
              self.appleSignInCompleted = true
              self.appleLoginCompletionHandler?(true)
              
              
          }
          
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

extension SessionManager : ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let rootViewController = windowScene.windows.first!
        return rootViewController
    }
    
}
