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
        ZStack {
            VStack(spacing: 0) {
                
                ZStack {
                    
            
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        
                        Image("loadingView")
                            .resizable()
                            .blur(radius: 2.5)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(20)
                            .frame(width: 350,height: 380)
                            .clipped()
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                        
                    }

                        ProgressView()
                        .font(.largeTitle)
                    
                }
            }
            .cornerRadius(20)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.6), radius: 4.5,x: 0,y: 0)
            )
        }
    }
}

struct EmptyCardView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCardView()
    }
}






