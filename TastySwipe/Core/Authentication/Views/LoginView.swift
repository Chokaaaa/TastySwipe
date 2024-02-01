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
    
    @State private var intros : [Intro] = sampleIntros
    @State private var activeIntros : Intro?
     
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel : AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        
//        GeometryReader {
//            let size = $0.size
//            let safeArea = $0.safeAreaInsets
//                
//                VStack(spacing: 0) {
//                    if let activeIntros {
//                        Rectangle()
//                            .fill(activeIntros.bgColor)
//                            .padding(.bottom, -30)
//                            .overlay {
//                                Circle()
//                                    .fill(.clear)
//                                Image(activeIntros.emoji)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 38, height: 38)
//                                    .background(alignment: .leading, content: {
//                                        Capsule()
//                                            .fill(activeIntros.bgColor)
//                                            .frame(width: size.width)
//                                    })
//                                    .background(alignment:.leading) {
//                                        Text(activeIntros.text)
//                                            .font(.largeTitle)
//                                            .foregroundStyle(activeIntros.textColor)
//                                            .frame(width: textSize(activeIntros.text))
//                                            .offset(x: 10)
//                                            .offset(x: activeIntros.textOffset)
//                                    }
//                                    .offset(x: -activeIntros.circleOffset)
//                            }
//                    }
//                    
//                    LoginButtons()
//                        .padding(.bottom,safeArea.bottom)
//                        .padding(.top,10)
//                        .background(.black, in: .rect(topLeadingRadius: 25, topTrailingRadius: 25))
//                        .shadow(color: .black.opacity(0.1), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 8)
//                    
//                }
//            .ignoresSafeArea()
//        }
        
//        
//        .task {
//            if activeIntros == nil {
//                activeIntros = sampleIntros.first
//                let nanoSecond = UInt64(1_000_000_000 * 0.5)
//                try? await Task.sleep(nanoseconds: nanoSecond)
//                animate(0)
//            }
//        }
        
        
        
        NavigationStack {
            
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                dismiss()
                            } label: {
                                dismissButton()
                            }
                        }
                        .padding(.trailing, 25)
                        
                        //MARK: - Image and title
                        
                        Text("Login to your Account")
                            .font(.system(size: 32, weight: .semibold, design: .rounded))
                            .padding(.top, 40)
                        
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
                                    ZStack {
                                        Image("mSignIn")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                    }
                                    .frame(width: 87, height: 60)
                                    .background(Color("TextFieldBg").cornerRadius(10))
                                }
                                
                                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .icon, state: .normal)) {
                                    
                                }
                                
                                
//                                Button {
                                    
                           
//                                    
//                                } label: {
//                                    ZStack {
//                                        Image("GSignIn")
//                                            .resizable()
//                                            .aspectRatio(contentMode: .fit)
//                                            .frame(width: 24, height: 24)
//                                    }
//                                    .frame(width: 87, height: 60)
//                                    .background(Color("TextFieldBg").cornerRadius(10))
//                                }
                                
                                
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
                //            .ignoresSafeArea(.keyboard, edges: .all)
            }
            
        }
    }
//    
//    func animate(_ index: Int, _ loop: Bool = true) {
//        if intros.indices.contains(index + 1) {
//            activeIntros?.text = intros[index].text
//            activeIntros?.textColor = intros[index].textColor
//            
//            withAnimation(.snappy(duration: 1), completionCriteria: .removed) {
//                activeIntros?.textOffset = -(textSize(intros[index].text) + 20)
//                activeIntros?.circleOffset = -(textSize(intros[index].text) + 20) / 2
//            } completion: {
//                withAnimation(.snappy(duration: 0.8), completionCriteria: .logicallyComplete) {
//                    activeIntros?.textOffset = 0
//                    activeIntros?.circleOffset = 0
//                    activeIntros?.emoji = intros[index + 1].emoji
//                    activeIntros?.bgColor = intros[index + 1].bgColor
//                } completion: {
//                    animate(index + 1, loop)
//                }
//            }
//        } else {
//            if loop {
//                animate(0, loop)
//            }
//        }
//    }
//    
//    func textSize(_ text: String) -> CGFloat {
//        return NSString(string: text).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle)]).width
//    }
//    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
