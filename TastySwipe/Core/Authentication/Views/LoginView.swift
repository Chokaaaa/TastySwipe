//
//  LoginView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 17/03/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Color.black.ignoresSafeArea()
                
                VStack {
                    
                    //MARK: - Image and title
                    
                        
                        Text("Login to your Account")
//                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .padding(.top, 100)
                    
                    //MARK: - Input fields
                    
                    VStack(spacing: 24) {
                        //Email
                        CustomInputField(text: $email, title: "Email", image: "email", placeHolder: "Email")
                            .font(.system(size: 14))
                        //Password
                        CustomInputField(text: $password, title: "Password", image: "password", placeHolder: "Password", isSecured: true)
                            .font(.system(size: 14))
                        
                        
                        
                        //MARK: - Sign in Button
                        
                        Button {
                            viewModel.signIn(withEmail: email, password: password)
                        } label: {
                                Text("Log in")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        }
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
                        .padding(.top,30)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top,44)
                    
                    
                    
                    Button {
                        
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 13,weight: .bold))
                            .padding(.top)
                    }
//                        .frame(maxWidth: .infinity, alignment: .leading)


                    
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
                        .padding(.top, 34)
                        
                        
                        HStack(spacing: 20) {
                            
                            Button {
                                
                            } label: {
//                                Image("mSignIn")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 25, height: 25)
//
//
//
                                ZStack {
                                    Image("mSignIn")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                }
                                        .frame(width: 87, height: 60)
                                        .background(Color("TextFieldBg").cornerRadius(10))
                            }
                        
//                            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .icon, state: .normal)) {
//
//                            }
                           

                            Button {

                            } label: {
                                ZStack {
                                    Image("GSignIn")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                }
                                        .frame(width: 87, height: 60)
                                        .background(Color("TextFieldBg").cornerRadius(10))
                            }
                            
                            
                            Button {
                                
                            } label: {
                                ZStack {
                                    Image("fSignIn")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                }
                                .frame(width: 87, height: 60)
                                .background(Color("TextFieldBg").cornerRadius(10))
                            }
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

                    
                    //MARK: - Sign up Button


                    
                }
                
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
