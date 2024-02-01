//
//  LoginButtons.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 16/01/2024.
//

import SwiftUI

struct LoginButtons: View {
    var body: some View {
        VStack(spacing: 20) {
            Button {
                
            } label: {
                
                HStack {
                    Image("fSignIn")
                        .padding(.bottom, 4)
                    
                    Text("Continue with Apple")

                }
                .foregroundStyle(.black)
                .fillButton(.white)
                
            }
            
            Button {
                
            } label: {
                
                HStack {
                    Image("fSignIn")
                        .padding(.bottom, 4)
                    
                    Text("Continue with Phone Number")

                }
                .foregroundStyle(.white)
                .fillButton(.black)
                
                
            }
            
            
            Button {
                
            } label: {
                
                HStack {
                    Image("fSignIn")
                        .padding(.bottom, 4)
                    
                    Text("Sign up with Email")

                }
                .foregroundStyle(.white)
                .fillButton(.black)
                
                
            }
            
            
            Button {
                
            } label: {
                
               Text("Login")
                .foregroundStyle(.white)
                .fillButton(.black)
                .shadow(color: .white, radius: 1)
                
            }

        }
        
        .padding([.leading, .trailing])
    }
}

#Preview {
    LoginButtons()
}
