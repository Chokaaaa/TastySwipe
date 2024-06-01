//
//  LoginView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 17/03/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices


struct SignInWithAppleButtonRepresentable : UIViewRepresentable {
    
    let type : ASAuthorizationAppleIDButton.ButtonType
    let style : ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
    
}

struct LoginView: View {
    
    @State private var intros : [Intro] = sampleIntros
    @State private var activeIntros : Intro?
     
    
    @State var email = ""
    @State var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @AppStorage("isOnboarding") var isOnboarding = true
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var sessionManager : SessionManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                if !isOnboarding {
                                    dismiss()
                                } else {
                                    isOnboarding = false
                                }
                            } label: {
                                dismissButton()
                            }
                        }
                        .padding(.trailing, 25)
                        
                        //MARK: - Image and title
                        
                        HStack {
                            Text("Login")
                                .font(.system(size: 32, weight: .semibold, design: .rounded))
                            Spacer()
                        }
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        
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
                                        sessionManager.currentUser = user
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
                        .padding(.horizontal)
                        .padding(.top,35)
                        
                        
                        
                        Button {
                            
                        } label: {
                            Text("Forgot Password ?")
                                .foregroundStyle(Color("PrimaryTextColor"))
                                .font(.system(size: 13,weight: .bold))
                                .padding(.top, 25)
                        }
                        
                        
                        
                        //MARK: - Social Sign in view
                        VStack {
                            HStack(spacing: 24) {
                                Rectangle().frame(width: 76, height: 1)
                                    .opacity(0.1)
                                
                                Text("or continue with")
                                    .fontWeight(.semibold)
                                    .opacity(0.5)
                                
                                Rectangle().frame(width: 76, height: 1)
                                    .opacity(0.1)
                            }
                            .padding(.top, 10)
                            
                            
                            VStack(spacing: 20) {
                                
                            
//                                //MARK: - Google sign IN
//                                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .icon, state: .normal)) {
//                                   
//                                }
                                
                                //MARK: - Google Sign-In
                                Button {
                                    sessionManager.googleSignIn { success in
                                        if success {
                                            dismiss()
                                        }
                                    }
                                } label: {
                                    ZStack {
                                        HStack {
                                            Image("GSignIn")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 24, height: 24)
                                            
                                            Text("Sign in with Google")
                                                .foregroundStyle(Color("PrimaryTextColor"))
                                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
//                                    .frame(width: .infinity, height: 60)
                                    .background(Color("googleButtonBg").opacity(1).cornerRadius(10))
//                                    .background(Color.gray.cornerRadius(10))
                                    .padding(.horizontal, 15)
                                }
                                
                                //MARK: - Apple Sign-In
                                
                                Button {
                                    sessionManager.startSignInWithAppleFlow()
                                } label: {
                                    SignInWithAppleButtonRepresentable(type: .signIn, style: .black)
                                    .allowsTightening(false)
                                }
                                .frame(height: 55)
                                .padding(.horizontal, 15)

                                
                            }
                            .padding(.top, 30)
                            
                        }
                        .padding(.vertical)
                        
                        
                        
                        Spacer()
                        
                        NavigationLink {
                            RegistrationView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            HStack {
                                Text("Dont have an account?")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.gray)
                                
                                Text("Sign Up")
                                    .font(.system(size: 12, weight: .bold))
                            }
                        }
                    }
                }
            }
            
        }
        
        .onChange(of: sessionManager.appleSignInCompleted) { oldValue, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

