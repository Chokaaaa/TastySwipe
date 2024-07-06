//
//  ContactUsView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 06/06/2024.
//

import SwiftUI

struct ContactUsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var FBAccountWeb: Bool = false
    @State private var InstaAccountWeb: Bool = false
    @State private var XAccountWeb: Bool = false
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color("settingTopBG"))
                    .frame(width: UIScreen.main.bounds.width, height: 135)
                    .ignoresSafeArea(.container, edges: .top)
            
               
            HStack(spacing: 85) {
                
                    //MARK: - Back Button
                    Button {
                        dismiss()
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
                    
                
//                Spacer()
                
                    Text("Contact us")
                        .bold()
                
                    Spacer()
                    
                }
            .padding([.leading, .trailing])
            .frame(maxWidth: .infinity)
            .padding(.top, -60)
                
            
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
                                                                     to: "NY@nykdevs.com")
            } label: {
                HStack(spacing: 15) {
                    Image("envelopeIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .padding(.leading, -10)
                    
                    
                    Text("info@nykdevs.com")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color("bgButton"))
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
//                .padding([.leading, .trailing], 10)
                .padding(.vertical, 15)
                .padding()
            
            VStack(alignment: .leading, spacing: 30) {
                
                Button {
                    FBAccountWeb.toggle()

                } label: {
                    socialMediaButton(image: "FBSocial", title: "Stay updated, connect, and engage with us on Facebook.")
                }
                .fullScreenCover(isPresented: $FBAccountWeb, content: {
                    SFSafariViewWrapper(url: URL(string: "https://www.facebook.com/profile.php?id=61561919794459")!)
                })
                
                
                Button {
                    XAccountWeb.toggle()
                } label: {
                    socialMediaButton(image: "xSocial", title: "Explore our visual world and discover beauty of our brand.")
                }
                .fullScreenCover(isPresented: $XAccountWeb, content: {
                    SFSafariViewWrapper(url: URL(string: "https://x.com/PlacesSwipe?mx=2")!)
                })
                
                
                Button {
                    InstaAccountWeb.toggle()
                } label: {
                    socialMediaButton(image: "InstaSocial", title: "Follow us for real-time updates and lively discussions.")
                }
                .fullScreenCover(isPresented: $InstaAccountWeb, content: {
                    SFSafariViewWrapper(url: URL(string: "https://www.instagram.com/placesswipe?igsh=cjVhODdlbjJncmRj&utm_source=qr")!)
                })
                
            }
            .padding(.trailing, 15)
            
            
            
        }
        .padding([.leading, .trailing], 15)
        .padding(.top, -50)
        Spacer()
    }
 
}

    

#Preview {
    ContactUsView()
}
