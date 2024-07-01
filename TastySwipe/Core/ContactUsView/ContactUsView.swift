//
//  ContactUsView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 06/06/2024.
//

import SwiftUI

struct ContactUsView: View {
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color("settingTopBG"))
                    .frame(width: UIScreen.main.bounds.width, height: 135)
                    .ignoresSafeArea(.container, edges: .top)
            
               
                HStack(spacing: 90) {
                    //MARK: - Back Button
                    Button {
                        
                    } label: {
                        VStack {
                            
                            Image("backButton")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 50, height: 50)
                        .padding(.leading, 0)
                        .foregroundColor(Color.black.opacity(0.8))
                        .background(Color("smallCirclebg"), in: Circle())
                    }
                    
                    Text("Contact us")
                        .bold()
                    
                    Spacer()
                    
                }
                .padding([.leading])
//                .padding(.bottom, 60)
                
            
        }
        VStack(alignment: .center, spacing: 10) {
            
            Text("Get in Touch")
                .font(.title)
                .foregroundStyle(.white)
                .bold()
                .padding([.leading, .trailing], 10)
                .padding(.top, 20)
            
            Text("If you have any inquiries get in touch with us Well be happy to help you.")
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .padding([.leading, .trailing], 15)
            
            Button {
                EmailController.shared.sendEmail(subject: "Support",
                                                                     body: """
                  Please describe your issue below
              
              
              
                ---------------------------------------
                Application Name: \(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown")
                iOS Version: \(UIDevice.current.systemVersion)
                Device Model: \(UIDevice.current.model)
                App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "no app version")
                App Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "no app build version")
              """,
                                                                     to: "nykdevs@gmail.com")
            } label: {
                HStack(spacing: 15) {
                    Image("envelopeIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .padding(.leading, -10)
                    
                    
                    Text("Developer Email")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.leading, 5)
                    
                    Spacer()
                }
                .padding()
                .padding(.leading, 10)
                
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 0.4)
                )
                
            }
            .padding(.top, 30)
            
            Text("Social Media")
                .font(.title)
                .foregroundStyle(.white)
                .bold()
                .padding([.leading, .trailing], 10)
                .padding(.top, 20)
            
            
            HStack {
                Image("")
                
                
                
            }
            
            
            
        }
        .padding([.leading, .trailing], 10)
        
    }
}

#Preview {
    ContactUsView()
}
