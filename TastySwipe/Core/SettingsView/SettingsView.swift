//
//  SettingsView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        
        VStack {
            TopHeaderView(headingText: "Profile")
//                .padding(.top,-25)
            VStack {
                ZStack {
                    
                    Image("bubles")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding([.leading,.trailing],15)
                    
                    Image("profileImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120, alignment: .center)
                    .clipShape(Circle())
                }
//                .padding(.top, 17.5)
                .padding(.top, 5.5)
                VStack(spacing: 5) {
                    Text("Nursultan Yelemessov")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    
                    Text("NursultanYelemessov@gmail.com")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.red)
                }
                .padding(.top)

            }
//            .padding()
            
            seperatorView()
                .padding([.leading,.trailing], 15)
            
            
            //MARK: - List
            Section {
                SettingsRow(image: "settingsProfile", text: "Profile")
                SettingsRow(image: "settingsAddress", text: "Address")
                SettingsRow(image: "settingsTicket", text: "Interests")
                SettingsRow(image: "settingsMore", text: "Language")
                SettingsRow(image: "settingsShow", text: "Dark Mode")
                SettingsRow(image: "settingsPrivacy", text: "Privacy Policy")
                SettingsRow(image: "settingsInvite", text: "Invite Friends")
                SettingsRow(image: "settingsLog", text: "Log Out")
                    .onTapGesture {
                        viewModel.signOut()
                        //MARK: - Need to create an alert to show that user is signed out check some libraries
                    }
                
            }
            .padding(.trailing,20)
            
        }
        .padding(10)
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
