//
//  RegistrationView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 17/03/2023.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var fullName : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @AppStorage("isOnboarding") var isOnboarding = true
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var sessionManager : SessionManager
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }
                
                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width:250)
                
                Spacer()
                
                VStack {
                    
                    VStack(spacing: 30) {
                        VStack {
                            
                            HStack {
                                Text("Enter your Full Name")
                                    .foregroundStyle(Color("PrimaryTextColor"))
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.leading, 12)
                            CustomInputField(text: $fullName, title: "Full Name", image: "nameIcon", placeHolder: "Please enter your name")
                        }
                        
                        VStack {
                            
                            HStack {
                                Text("Enter your Email")
                                    .foregroundStyle(Color("PrimaryTextColor"))
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.leading, 12)
                            CustomInputField(text: $email, title: "Email", image: "email", placeHolder: "name@example.com")
                        }
                        
                        VStack {
                            
                            HStack {
                                Text("Enter your Password")
                                    .foregroundStyle(Color("PrimaryTextColor"))
                                    .font(.system(size: 14))
                                Spacer()
                            }
                            .padding(.leading, 12)
                            CustomInputField(text: $password, title: "Password", image: "password", placeHolder: "Please enter your password", isSecured: true)
                        }
                    }
                    
                    .padding(.horizontal, 15)
                    
                    Button {
                        viewModel.registerUser(withEmail: email, password: password, fullName: fullName) { user in
                            if let user = user {
                                sessionManager.currentUser = user
                                isOnboarding = false
                            }
                            dismiss()
                        }
                        
                    } label: {
                        Text("Register")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 55)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                    .padding(.top,30)
                    
                    Spacer()
                    
                    
                }
            }
        }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
