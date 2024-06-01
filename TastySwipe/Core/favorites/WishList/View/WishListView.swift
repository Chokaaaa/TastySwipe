//
//  WishListView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/01/2024.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import FirebaseAuth
import Lottie

struct WishListView: View {
    
    @Binding var tabSelection: Int
    @EnvironmentObject var viewModel: WishListViewModel
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isShowingPayWall = false
    
    let columns : [GridItem] = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                if viewModel.wishList.count > 0 {
                    
                    LazyVGrid(columns: columns) {
                        
                        ForEach(viewModel.wishList, id: \.self) { wishList in
                            FavoriteCardView(image: wishList.image,
                                             title: wishList.title,
                                             id: wishList.id)
                        }
                    }
                    .padding()
                    
                    
                } else {
                    
                    VStack{
                            
                            // MARK: Movable Slides
                            VStack{
                                
                                    Image("magnifyingGlass")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 285, height: 285, alignment: .center)
                                
                                
                                VStack(spacing: 25) {
                                    
                                    Text("You have no favorites yet")
                                        .font(.title.bold())
                                    
                                    
                                    
                                    Text("Sorry, you didn’t like any shop yet, no worries you may like them after.")
                                        .font(.system(size: 14))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal,15)
                                        .foregroundColor(.gray)
                                    //                            .padding(.bottom, 10)
                                    
                                
                   
                                Button {
                                    tabSelection = 0
                                } label: {
                                    Text("Discover")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.vertical,20)
                                        .frame(maxWidth: .infinity)
                                        .background {
                                            Capsule()
                                                .fill(Color.accentColor)
                                        }
                                        .padding(.horizontal,20)
                                }
                                }
                            }
                            .padding(.top, 85)
                        }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                
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
//                                    .paywallFooter(condensed: false)
                            }
                            
                          
                        } else {
                            
                        }
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "person.3")
//                                .foregroundStyle(Color.accentColor)
//                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.createWishListObserver()
        }
        
    }
}

#Preview {
    WishListView(tabSelection: .constant(1))
}
