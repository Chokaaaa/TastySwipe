//
//  TopHeaderView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI

struct TopHeaderView: View {
    
    var headingText : String
    
    var body: some View {
        // MARK: Top Nav Bar
        HStack{
            
            HStack {
                Image("LoginImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40, alignment: .leading)
                    .cornerRadius(10)
                
                Text(headingText)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                
            }
            
            Spacer(minLength: 0)
            
            Button(action: {
                
            }, label: {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25, alignment: .leading)
                    .foregroundColor(.black)
                    .opacity(0.6)
            })
            

     
        }
//        .padding(.top, -100)
        .padding([.leading,.trailing], 10)
        .tint(Color.accentColor)
        .fontWeight(.bold)
    }
}

struct TopHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeaderView(headingText: "Profile")
    }
}
