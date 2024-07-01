//
//  TopHeaderView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI
//import RevenueCat
//import RevenueCatUI

struct TopHeaderView: View {
    
    var headingText : String
    
    @State private var isShowingPayWall = false
    @State private var isSubscribed = false
    
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

            if !isSubscribed {
                
                Button(action: {
                    isShowingPayWall = true
                }, label: {
                    Text("Buttons")
                })
//                .fullScreenCover(isPresented: $isShowingPayWall) {
//                    PaywallView()
//                        .padding([.leading, .trailing], -100)
////                        .paywallFooter(condensed: false)
//                }
                
            } else {
                Button(action: {
                    isShowingPayWall = false
                }, label: {
                    Text("Subscribed ✅")
                })
            }
            
            
            
            //            .padding()
            
            
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
        
        .onAppear {
            checkSubscriptionStatus()
            print("Is Subscribed \(isSubscribed)")
        }
        
        
    }
    
    func checkSubscriptionStatus() {
//        Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
//            if let purchaserInfo = purchaserInfo {
//                // Check if user is subscribed
//                isSubscribed = purchaserInfo.entitlements.all["your_entitlement_identifier"]?.isActive ?? false
//            }
//            if let error = error {
//                print("Error fetching subscription info: \(error.localizedDescription)")
//            }
//        }
    }
    
    
}

struct TopHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TopHeaderView(headingText: "Profile")
    }
}
