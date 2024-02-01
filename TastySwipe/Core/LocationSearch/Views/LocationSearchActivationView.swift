//
//  LocationSearchActivationView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 09/03/2023.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: 150, alignment: .center)
                .cornerRadius(20)
                .foregroundColor(Color("SearchBackgroundColor"))
            
            
            HStack {
                
                Image(systemName: "house")
                    .foregroundColor(.blue)
                
                Text("Explore")
                .font(.title2)
                .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "person.3")
                    .foregroundColor(.white)
//                    .padding(.trailing, 20)
                
            }
            .padding([.leading, .trailing], 25)
                
    
                HStack {
//                    Rectangle()
//                        .fill(Color.black)
//                        .frame(width: 8, height: 8)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(.darkGray))
                        .padding(.leading,15)
                    
                    
                    Text("Search")
                        .foregroundColor(Color(.darkGray))
                    
                    Spacer()
                }
    //            .frame(width: UIScreen.main.bounds.width - 124, height: 50)
                .frame(width: UIScreen.main.bounds.width - 40, height: 65)
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(22)
                        .shadow(color: .black, radius: 3)
            )
            .padding(.top, 140)
        }
    }
}

struct LocationSearchActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchActivationView()
    }
}
