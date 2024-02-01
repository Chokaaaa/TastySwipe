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
    
    @StateObject var viewModel = WishListViewModel()
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isShowingPayWall = false
    
    
    
    
    
    
    let columns : [GridItem] = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                if viewModel.wishList.count > 0 {
                    
                    LazyVGrid(columns: columns) {
                        
                        ForEach(viewModel.wishList.indices, id: \.self) { index in
                            FavoriteCardView(image: viewModel.wishList[index].image,
                                             title: viewModel.wishList[index].title,
                                             id: viewModel.wishList[index].id)
                        }
                    }
                    .padding()
                    
                    
                } else {
                    VStack {
                        
                        
                        
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
                        Button {
                            
                        } label: {
                            Image(systemName: "person.3")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
            }
        }
        
        
    }
}

#Preview {
    WishListView()
}
