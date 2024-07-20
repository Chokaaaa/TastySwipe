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
    @ObservedObject var loginNavigationManager: LoginNavigationManager
    @AppStorage("isOnboarding") var isOnboarding = true
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var sessionManager : SessionManager
    @EnvironmentObject var tabManager : TabManager
    @Environment(\.dismiss) private var dismiss
    let didPresentFromSettings: Bool
    
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
                                if textFieldValidatorEmail(phoneNumber) {
                                    loginNavigationManager.showEmailView = true
                                } else {
                                    Task {
                                        do {
                                            let verificationCode = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
                                            print("Verification Code \(verificationCode)")
                                            loginNavigationManager.verificationDetails = VerificationDetails(code: verificationCode, phoneNumber: phoneNumber)
                                        } catch {
                                            print(error.localizedDescription)
                                            print("Wrong Phone number")
                                        }
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
                                            tabManager.showHiddenTab = didPresentFromSettings ? true : false
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
                                    sessionManager.startSignInWithAppleFlow(appleLoginCompletionHandler: { success in
                                        if success {
                                            tabManager.showHiddenTab = didPresentFromSettings ? true : false
                                            isOnboarding = false
                                            dismiss()
                                        }
                                    })
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
            .navigationDestination(item: $loginNavigationManager.verificationDetails) { verificationDetails in
                OtpView(loginNavigationManager: loginNavigationManager, phoneNumber: phoneNumber, verificationDetails: verificationDetails)
            }
            
            
            .navigationDestination(isPresented: $loginNavigationManager.showEmailView) {
                LoginPasswordView(loginNavigationManager: loginNavigationManager, email: phoneNumber, didPresentFromSettings: didPresentFromSettings)
            }
            
            
            
        }
        
//                .onChange(of: sessionManager.appleSignInCompleted) { oldValue, newValue in
//                    if newValue {
//                        dismiss()
//                    }
//                }
//                .navigationBarBackButtonHidden(true)
   
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginNavigationManager: LoginNavigationManager(), didPresentFromSettings: false)
            .environmentObject(SessionManager())
    }
}

