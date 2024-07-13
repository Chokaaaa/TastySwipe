//
//  loggedOutView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

struct loggedOutView: View {
    @State private var showingLoginView = false
    @State private var isShowingPayWall = false
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var sessionManager : SessionManager
    @ObservedObject var purchasesManager = PurchasesManager()
    
    var body: some View {
            
            VStack(spacing: 25){
                
                HStack(spacing: 69) {
                    
                    //MARK: - Profile Icon
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        VStack {
                            
                            Image("userIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.black.opacity(0.8))
                        //                            .background(.ultraThinMaterial, in: Circle())
                        .background(Color("NavBarBGColor"), in: Circle())
                    }
                    
                    
                    //MARK: - Text
                    
                    Text("Favorites")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    
                    
                    //MARK: - Become a Pro Button
                    if purchasesManager.isSubscriptionActive == false {
                        Button {
                            isShowingPayWall = true
                        } label: {
                            VStack {
                                
                                Image("starsIcon")
                                    .resizable()
                                    .foregroundStyle(Color.accentColor)
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                
                                
                            }
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.black.opacity(0.8))
                            .background(Color("NavBarBGColor"), in: Circle())
                        }
                        
                        
                    } else {
                        
                        VStack {
                            
                            Image("")
                                .resizable()
                                .foregroundStyle(Color.accentColor)
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.clear)
                        .background(Color.clear, in: Circle())
                    }
                    
                }
                
                
                // MARK: Movable Slides
                    VStack(spacing: 15){
                        
                        //                            Image("ghostImage")
                        //                            .resizable()
                        //                            .aspectRatio(contentMode: .fit)
                        //                            .frame(width: 285, height: 285, alignment: .center)
                        
                      WishList3DView()
                        .frame(height: 400, alignment: .center)
                        
                        Text("You have no account yet")
                            .font(.title.bold())
                        
                        
                        Text("Sorry, you didn’t create an account yet, no worries you may open an account by clicking the button below.")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .lineLimit(5)
                            .padding(.horizontal,15)
                            .foregroundColor(.gray)
                        //                            .padding(.bottom, 10)
                        
                        
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
                            //                                .padding(.top, 20)
                        }
                        
                        Spacer()
                    }
                
                
            }
            
            .fullScreenCover(isPresented: $showingLoginView) {
                LoginView()
            }
            
            
            .fullScreenCover(isPresented: $isShowingPayWall) {
                PaywallView()
                    .padding([.leading, .trailing], -100)
                
            }
    }
}

struct loggedOutView_Previews: PreviewProvider {
    static var previews: some View {
        loggedOutView()
    }
}
