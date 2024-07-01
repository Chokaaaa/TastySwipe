//
//  loggedOutView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI
//import RevenueCat
//import RevenueCatUI

struct loggedOutView: View {
    @State private var showingLoginView = false
    @State private var isShowingPayWall = false
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var sessionManager : SessionManager
    @ObservedObject var purchasesManager = PurchasesManager()
    
    var body: some View {
//        HStack(spacing: 0){
        
        NavigationStack {
            
            VStack(spacing: 60){
                    
                    // MARK: Movable Slides
                    VStack(spacing: 15){
                        
                            Image("ghostImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 285, height: 285, alignment: .center)
                        
                        
                        
                            Text("You have no account yet.")
                                .font(.title.bold())
                                .padding(.top, 50)
                        
                        
                        
                        Text("Sorry, you didn’t create an account yet, no worries you may open an account by clicking the button below.")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .lineLimit(5)
                            .padding(.horizontal,15)
                            .foregroundColor(.gray)
//                            .padding(.bottom, 10)
                        
                    }
                    
                    // MARK: Next / Login Button
                    VStack(spacing: 15){
                        
                        Button {
                            if sessionManager.currentUser == nil {
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
                                .padding(.top, 20)
                        }

                    }
                    .padding(.bottom, 50)
                    .fullScreenCover(isPresented: $showingLoginView) {
                        LoginView()
                    }
                }
            .padding(.top,50)
                .padding(10)
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .topBarLeading) {
                      
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        HStack {
                            if purchasesManager.isSubscriptionActive == false {
                                Button {
                                    isShowingPayWall = true
                                } label: {
                                    HStack(spacing: 0) {
                                        Text("💎")
                                            .foregroundStyle(Color.yellow)
                                            .frame(width: 25, height: 0)
                                        Text("PRO")
                                            .fontWeight(.bold)
                                    }
                                    .padding(5)
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .clipShape(
                                        Capsule()
                                    )
                                }
                                .fullScreenCover(isPresented: $isShowingPayWall) {
                                    PaywallView()
                                        .padding([.leading, .trailing], -100)
//                                        .paywallFooter(condensed: false)
                                }
                            } else {
                                
                            }
//                            
//                            Button {
//                                
//                            } label: {
//                                Image(systemName: "person.3")
//                                    .foregroundStyle(Color.accentColor)
//                            }
                        }
                    }
                }
            }
        }
    }

struct loggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        loggedOutView()
    }
}
