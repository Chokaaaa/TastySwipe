//
//  CardView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 11/03/2023.
//

import SwiftUI

struct CardView: View, Identifiable {
    
    var title : String
    var location : String
    var image : String
    var category : String
    
    let id = UUID()
    
    @State private var showingLoginView = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                //MARK: - Image
                ZStack(alignment: .top) {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                    HStack(spacing: 0) {
                        Image("nearkm")
                            .scaledToFit()
                            .padding(.leading,5)
                        Text("3 km")
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.trailing,5)
                            .frame(width: 45, height: 35)
                    }
                    .background(
                        .thinMaterial,
                        in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                                   )
                    .frame(width: 90, height: 35.35)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
                            
//                    )
                        .padding(.top,15)
                        .padding(.trailing,140)
                }
                .frame(width: 240, height: 250, alignment: .center)
                //MARK: - Text(title,category,location)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 25, design: .rounded))
                        .fontWeight(.bold)
                        .padding(.horizontal, 15)
                        .padding(.top,10)
                   
                    Text(category)
                        .font(.system(size: 18, design: .rounded))
                        .fontWeight(.regular)
                        .padding(.horizontal, 15)
                    
                    Text(location)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.gray)
                        .fontWeight(.regular)
                        .padding(.horizontal, 15)
                        
                    Spacer()
                }

                .frame(maxWidth: 240, maxHeight: 115, alignment: .leading)
                                
            }
            .cornerRadius(40)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(40)
                    .shadow(color: .gray.opacity(0.5), radius: 10,x: 0,y: 0)
            )
//            .overlay(
            HStack {
                Button {
                    print("dislike")
                } label: {
                    Image("dislike")
                        .frame(width: 46, height: 46)
                        .background(.white)
                        .cornerRadius(23)
                        .shadow(color: .gray.opacity(0.5), radius: 10,x: 0,y: 0)
                }

               
                Button {
                    showingLoginView.toggle()
                } label: {
                    Image("whishlist")
                        .frame(width: 64, height: 64)
                        .background(.white)
                        .cornerRadius(32)
                        .shadow(color: .gray.opacity(0.5), radius: 10,x: 0,y: 0)
                }
                
                Button {
                    print("like")
                } label: {
                    Image("like")
                        .frame(width: 46, height: 46)
                        .background(.white)
                        .cornerRadius(23)
                        .shadow(color: .gray.opacity(0.5), radius: 10,x: 0,y: 0)
                }
            }
            .sheet(isPresented: $showingLoginView) {
                LoginView()
            }
                .padding(.bottom,-30)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "PF.Changs", location: "Jumeirah 1", image: "PF.Changs", category: "Restraunt")
    }
}