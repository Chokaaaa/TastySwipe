//
//  loggedOutView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI

struct loggedOutView: View {
    @State private var showingLoginView = false
    @EnvironmentObject var authViewModel : AuthViewModel
    var body: some View {
//        HStack(spacing: 0){
            VStack(spacing: 60){
             
                TopHeaderView(headingText: "Profile")
                    
                    // MARK: Movable Slides
                    VStack(spacing: 15){
                        
                            Image("ghostImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 285, height: 285, alignment: .center)
                        
                        
                        
                            Text("You have no account yet.")
                                .font(.title.bold())
                                .padding(.top, 50)
                        
                        
                        
                        Text("Sorry, you didn’t create an account yet, no worries you may open an account by clicking the button below. ")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,15)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                        
                    }
                    
                    // MARK: Next / Login Button
                    VStack(spacing: 15){
                        
                        Button {
                            if authViewModel.userSession == nil {
                                showingLoginView.toggle()
                            } else {
                                print("User is logged in already")
                            }
                        } label: {
                            Text("Create account")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
    //                                .padding(.vertical,isLastSlide ? 13 : 12)
                                .padding(.vertical,20)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(Color.accentColor)
                                }
    //                                .padding(.horizontal,isLastSlide ? 30 : 100)
                                .padding(.horizontal,20)
                        }

                    }
                    .padding(.bottom, 50)
                    .sheet(isPresented: $showingLoginView) {
                        LoginView()
                    }
                }
                .padding(10)
//            }
        }
    }

struct loggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        loggedOutView()
    }
}
