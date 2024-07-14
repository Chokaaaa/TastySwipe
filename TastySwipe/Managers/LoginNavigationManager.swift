//
//  LoginViewModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 14/07/2024.
//

import Foundation

class LoginNavigationManager: ObservableObject {
    
    @Published var showOTPView = false
    @Published var showLoginView = false
    @Published var verificationDetails: VerificationDetails?
    @Published var showEmailView = false
}
