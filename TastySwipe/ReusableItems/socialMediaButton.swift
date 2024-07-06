//
//  socialMediaButtons.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 05/07/2024.
//

import SwiftUI

struct socialMediaButton: View {
    var image : String
    var title : String
    var body: some View {
        HStack(spacing: 30) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(title)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .opacity(0.5)
        }
    }
}

#Preview {
    socialMediaButton(image: "FBSocial", title: "Stay updated, connect, and engaged with us on Facebook.")
}
