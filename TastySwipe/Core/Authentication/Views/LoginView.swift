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
import FirebaseAuth

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
    
    @State var phoneNumber = ""
    @State var email = ""
    @State var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State var verificationDetails: VerificationDetails?
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
                        .padding(.trailing, 25)
                        
                        //MARK: - Image and title
                        VStack(spacing: 15) {
                            HStack {
                                Spacer()
                                Text("Locale Swipe")
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                Spacer()
                            }
                            
                            Text("Welcome Back")
                                .font(.system(size: 20, weight: .thin))
                            
                        }
                        //MARK: - Input fields
                        
                        //                        VStack(spacing: 34) {
                        //                            //Email
                        //                            VStack {
                        //                                HStack {
                        //                                    Text("Email")
                        //                                        .foregroundStyle(Color("PrimaryTextColor"))
                        //                                        .font(.system(size: 14))
                        //                                    Spacer()
                        //                                }
                        //                                .padding(.leading, 12)
                        //                                CustomInputField(text: $email, title: "Email", image: "email", placeHolder: "Enter your email")
                        //                                    .font(.system(size: 14))
                        //                            }
                        //                            //Password
                        //                            VStack {
                        //
                        //                                HStack {
                        //                                    Text("Password")
                        //                                        .foregroundStyle(Color("PrimaryTextColor"))
                        //                                        .font(.system(size: 14))
                        //                                    Spacer()
                        //                                }
                        //                                .padding(.leading, 12)
                        //
                        //                                CustomInputField(text: $password, title: "Password", image: "password", placeHolder: "Enter your password", isSecured: true)
                        //                                    .font(.system(size: 14))
                        //                            }
                        //
                        //                            //MARK: - Sign in Button
                        //
                        //                            Button {
                        //                                viewModel.signIn(withEmail: email, password: password) { user in
                        //                                    if let user = user {
                        ////                                        sessionManager.currentUser = user
                        //                                        isOnboarding = false
                        //                                        dismiss()
                        //                                    } else {
                        //
                        //
                        //                                        if email == "" {
                        //                                            alertTitle = "Sorry"
                        //                                            alertMessage = "Email is an empty field"
                        //                                            alertMessage = "Sorry you cannot leave an email empty"
                        //                                        }
                        //
                        //                                        if password == "" {
                        //                                            alertTitle = "Sorry"
                        //                                            alertMessage = "Password is an empty field"
                        //                                            alertMessage = "Sorry you cannot leave a password empty"
                        //                                        }
                        //
                        //                                        alertTitle = "Sorry"
                        //                                        alertMessage = "Email or Password is wrong"
                        //                                        showAlert = true
                        //                                    }
                        //                                }
                        //                            } label: {
                        //                                Text("Log in")
                        //                                    .foregroundColor(.white)
                        //                                    .frame(width: UIScreen.main.bounds.width - 32, height: 55)
                        //                            }
                        //                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                        //                            .padding(.top,30)
                        //
                        //                        }
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Phone number or Email")
                                .foregroundStyle(Color("innactiveButtonColorDarkBlue"))
                            HStack(spacing: 15) {
                                
                                TextField("Enter", text: $phoneNumber)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(Color("bgButton"))
                                    .padding(.leading, 5)
                                
                                Spacer()
                            }
                            .padding()
                            .padding(.leading, 0)
                            
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("innactiveButtonColorDarkBlue"), lineWidth: 1)
                            )
                            
                            Text("You will receive an SMS verification that may apply message and data rates.")
                                .font(.system(size: 12.5))
                                .foregroundStyle(Color("innactiveButtonColorDarkBlue"))
                            
                            Button {
                                Task {
                                    do {
                                        let verificationCode = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
                                        print("Verification Code \(verificationCode)")
                                        verificationDetails = VerificationDetails(code: verificationCode, phoneNumber: phoneNumber)
                                    } catch {
                                        print(error.localizedDescription)
                                        print("Wrong Phone number")
                                    }
                                }
                            } label: {
                                Text("Next")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.vertical,20)
                                    .frame(maxWidth: .infinity)
                                    .background {
                                        if phoneNumber.count <= 0 {
                                        Capsule()
                                            .fill(Color("innactiveButtonColorDarkBlue"))
                                        } else {
                                            Capsule()
                                            .fill(Color.accentColor)
                                        }
                                    }
                                    .padding(.horizontal,0)
                            }
                            .padding(.top, 50)
                            
                        }
                        
                        .padding(.horizontal)
                        .padding(.top,35)
                        
                        
                        //MARK: - Social Sign in view
                        VStack {
                            HStack {
                                //                                Rectangle().frame(width: 100, height: 1)
                                //                                    .opacity(0.3)
                                Spacer()
                                Text("OR")
                                    .fontWeight(.semibold)
                                    .opacity(0.5)
                                Spacer()
                                //                                Rectangle().frame(width: 100, height: 1)
                                //                                    .opacity(0.3)
                            }
                            .padding(.top, 10)
                            
                            
                            VStack(spacing: 30) {
                                
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
                                    
                                    .background(Color("googleButtonBg")
                                    .cornerRadius(10)
                                    .padding(.horizontal, 15))
                                }
                                
                                //MARK: - Apple Sign-In
                                
                                Button {
                                    sessionManager.startSignInWithAppleFlow()
                                } label: {
                                    SignInWithAppleButtonRepresentable(type: .signIn, style: .white)
                                        .allowsTightening(false)
                                }
                                .frame(height: 55)
                                .padding(.horizontal, 15)
                                
                                
                            }
                            .padding(.top, 30)
                            
                        }
                        .padding(.vertical)
                        
                        VStack(spacing: 20) {
                            Text("Don't have an account yet?")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.white)
                            
                            
                            NavigationLink {
                                RegistrationView()
                                    .navigationBarBackButtonHidden(true)
                            } label: {
                                HStack {
                                    
                                    Text("Sign Up")
                                        .font(.system(size: 15, weight: .bold))
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationDestination(item: $verificationDetails) { verificationDetails in
                OtpView(verificationDetails: verificationDetails)
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
            .environmentObject(SessionManager())
    }
}

