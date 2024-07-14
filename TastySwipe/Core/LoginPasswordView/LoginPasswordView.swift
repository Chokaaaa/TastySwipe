//
//  LoginPasswordView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 14/07/2024.
//

import SwiftUI

struct LoginPasswordView: View {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    @State var email: String
    @ObservedObject var loginNavigationManager: LoginNavigationManager
    @State var password = ""
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if !isOnboarding {
                        dismiss()
                    } else {
                        isOnboarding = false
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }
                Spacer()
            }
            .padding(.vertical)
            
            //MARK: - Input fields
            
                                    VStack(spacing: 34) {
                                        //Email
                                        VStack {
                                            HStack {
                                                Text("Email")
                                                    .foregroundStyle(Color("PrimaryTextColor"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(.leading, 12)
                                            CustomInputField(text: $email, title: "Email", image: "email", placeHolder: "Enter your email")
                                                .font(.system(size: 14))
                                        }
                                        //Password
                                        VStack {
            
                                            HStack {
                                                Text("Password")
                                                    .foregroundStyle(Color("PrimaryTextColor"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(.leading, 12)
            
                                            CustomInputField(text: $password, title: "Password", image: "password", placeHolder: "Enter your password", isSecured: true)
                                                .font(.system(size: 14))
                                        }
            
                                        //MARK: - Sign in Button
            
                                        Button {
                                            viewModel.signIn(withEmail: email, password: password) { user in
                                                if let user = user {
            //                                        sessionManager.currentUser = user
                                                    isOnboarding = false
                                                    dismiss()
                                                } else {
            
            
                                                    if email == "" {
                                                        alertTitle = "Sorry"
                                                        alertMessage = "Email is an empty field"
                                                        alertMessage = "Sorry you cannot leave an email empty"
                                                    }
            
                                                    if password == "" {
                                                        alertTitle = "Sorry"
                                                        alertMessage = "Password is an empty field"
                                                        alertMessage = "Sorry you cannot leave a password empty"
                                                    }
            
                                                    alertTitle = "Sorry"
                                                    alertMessage = "Email or Password is wrong"
                                                    showAlert = true
                                                }
                                            }
                                        } label: {
                                            Text("Log in")
                                                .foregroundColor(.white)
                                                .frame(width: UIScreen.main.bounds.width - 32, height: 55)
                                        }
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                                        .padding(.top,30)
            
                                    }
            
            
        }
        Spacer()
    }
}

#Preview {
    LoginPasswordView(email: "LocaleSwipe@gmail.com", loginNavigationManager: LoginNavigationManager())
}
