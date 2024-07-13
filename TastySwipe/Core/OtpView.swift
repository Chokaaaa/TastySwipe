//
//  SwiftUIView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 13/07/2024.
//

import SwiftUI
import FirebaseAuth

struct OtpView: View {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    @Environment(\.dismiss) private var dismiss
    let verificationDetails: VerificationDetails
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if !isOnboarding {
                        dismiss()
                    } else {
                        isOnboarding = false
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }
                Spacer()
            }
            
            
                HStack {
                    Spacer()
                    Text("Enter authentication code")
                        .font(.system(size: 32, weight: .semibold, design: .rounded))
                    Spacer()
                }
                
                Text("Enter the 4-digit that we have sent via the phone number +1 (555) 555-1234")
                    .font(.system(size: 20, weight: .thin))
                
            Button {
                
            } label: {
                Text("Next")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical,20)
                    .frame(maxWidth: .infinity)
                    .background {
//                        if email.count <= 0 {
//                        Capsule()
//                            .fill(Color("innactiveButtonColorDarkBlue"))
//                        } else {
                            Capsule()
                            .fill(Color.accentColor)
//                        }
                    }
                    .padding(.horizontal,0)
            }
            .padding(.top, 50)
            
        }
    }
}

#Preview {
    OtpView(verificationDetails: VerificationDetails(code: "1234", phoneNumber: "+971554258496"))
}
