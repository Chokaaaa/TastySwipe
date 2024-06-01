//
//  CustomInputField.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 17/03/2023.
//

import SwiftUI

struct CustomInputField: View {
    
    @Binding var text: String
    let title : String
    let image : String
    let placeHolder : String
    var isSecured = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
//            Text(title)
//                .foregroundColor(.black)
//                .fontWeight(.semibold)
//                .font(.footnote)
//                .padding(.leading, 5)
            
            HStack {
                
//                Image(image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 20, height: 20)
                
                
            
                
                if isSecured == false {
                    TextField(placeHolder, text: $text)
                        
                } else {
                    SecureField(placeHolder, text: $text)
                }
            }
//            .padding()
            Divider()
//            .background(Color("TextFieldBg").cornerRadius(10))
        
        }
        .padding([.leading, .trailing], 15)
        
    }
}

struct CustomInputField_Previews: PreviewProvider {
    static var previews: some View {
        CustomInputField(text: .constant(""), title: "Email", image: "email", placeHolder: "Enter your email", isSecured: false)
    }
}
