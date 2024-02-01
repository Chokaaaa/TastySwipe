//
//  EmptyCardView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 06/01/2024.
//

import SwiftUI
import StarRatingViewSwiftUI

struct EmptyCardView: View {
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                //MARK: - Image
                ZStack(alignment: .top) {
                    Image("loading")
                        .resizable()
                        .scaledToFill()
                    HStack(spacing: 0) {
                        Image("nearkm")
                            .scaledToFit()
                            .padding(.leading,5)
                        Text("Text")
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.trailing,5)
                            .frame(width: 80, height: 45)
                    }
                    .background(
                        .thinMaterial,
                        in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                    )
                    .frame(width: 90, height: 35.35)
                    //                    .background(
                    //                        RoundedRectangle(cornerRadius: 20)
                    
                    //                    )
                    .padding(.top,30)
                    .padding(.trailing,230)
                }//MARK: - End of ZStack
                .frame(width: 350, height: 320, alignment: .center)
                //MARK: - Text(title,category,location)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Text")
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.horizontal, 15)
                            
                        
                        Spacer()
                        
                        //MARK: - Raiting
                        StarRatingView(rating: 0, color: Color.yellow, maxRating: 5)
                            .frame(width: 25, height: 15, alignment: .leading)
                            .padding(.trailing, 60)
                        Text(String(format: "%.1f", 0))
                            .foregroundStyle(.yellow)
                            
                    }
                    .padding(.top,20)
                    
                    
                    Text("Category")
                        .font(.system(size: 14, design: .rounded))
                        .fontWeight(.regular)
                        .padding(.horizontal, 15)
                    
                    
                    Text("Location")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.gray)
                        .fontWeight(.regular)
                        .padding(.horizontal, 15)
                    
                    Spacer()
                }
                
                .frame(maxWidth: 340, maxHeight: 160, alignment: .leading)
                
            }
            .cornerRadius(40)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.6), radius: 2.5,x: 0,y: 0)
            )
            //MARK: - Action Buttons
            .overlay(
                HStack(spacing: 15) {
                    
                    //MARK: - Dislike
//                    Button {
//                        print("dislike")
//                    } label: {
                        Image(systemName: "hand.thumbsdown")
                            .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
//                    }
                    
                    
                    //MARK: - Create route
//                    Button {
//                        print("dislike")
//                    } label: {
                        Image(systemName: "location")
                            .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
//                    }
                    
                    
                    //MARK: - Add to wishlist
//                    Button {
//                       
//                        } else {
//                            showingLoginView.toggle()
//                        }
//                    } label: {
                        Image(systemName: "star")
                            .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
//                    }
                    
                    //MARK: - Web
//                    Button {
//                        print("like")
//                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
//                    }
                    
                    
                    //MARK: - Like
//                    Button {
//                        print("like")
//                    } label: {
                        Image(systemName: "hand.thumbsup")
                            .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
//                    }
                }
                    .padding(.top, 410)
            )
            
            .padding(.bottom,-170)
        }
    }
}

//struct EmptyCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmptyCardView(title: "PF.Changs", location: "Jumeirah 1", image: "PF.Changs", category: "Restraunt", distance: 2, rating : 5, id: "1")
//    }
//}






