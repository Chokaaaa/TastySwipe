//
//  WishListView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/01/2024.
//

import SwiftUI
//import RevenueCat
//import RevenueCatUI
import FirebaseAuth
//import Lottie

struct WishListView: View {
    
    @Binding var tabSelection: Int
    @EnvironmentObject var viewModel: WishListViewModel
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isShowingPayWall = false
    
    let columns : [GridItem] = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    
    var body: some View {
//        NavigationStack {
        
        ZStack(alignment: .center) {
            
            Color.black.ignoresSafeArea(edges: .all)
            
            VStack {
                
                HStack(spacing: 60) {
                    
                    //MARK: - Profile Icon
                    
                    Button {
                        
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
                    
                    Text("Locale Link")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    
                    
                    //MARK: - AI Button
                    
                    Button {
                        
                    } label: {
                        VStack {
                            
                            Image("starsIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.black.opacity(0.8))
                        .background(Color("NavBarBGColor"), in: Circle())
                    }
                    
                    
                }
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
            }
        }
//            .navigationTitle("Favorites")
//            .navigationBarTitleDisplayMode(.inline)
             
//        }
        .onAppear {
            viewModel.createWishListObserver()
        }
        
    }
}

#Preview {
    WishListView(tabSelection: .constant(1))
}
