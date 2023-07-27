//
//  RegistrationView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 17/03/2023.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var fullName : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                    
                }
                
                Text("Create new account")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .frame(width:250)
                
                Spacer()
                
                VStack {
                    
                    VStack(spacing: 30) {
                        CustomInputField(text: $fullName, title: "Full Name", image: "nameIcon", placeHolder: "Please enter your name")
                        CustomInputField(text: $email, title: "Email", image: "email", placeHolder: "name@example.com")
                        CustomInputField(text: $password, title: "Password", image: "password", placeHolder: "Please enter your password", isSecured: true)
                    }
                    .padding([.leading,.trailing])
                    
                    Spacer()
                    
                   
                    
                    
                    Button {
                        viewModel.registerUser(withEmail: email, password: password, fullName: fullName)
                        dismiss()
                    } label: {
                            Text("SIGN UP")
                            .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    }
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
//                    .padding(.top,-100)

                    Spacer()
                }
            }
        }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
