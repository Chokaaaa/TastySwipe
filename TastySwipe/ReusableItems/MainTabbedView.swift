//
//  ContentView.swift
//  CustomTabbarSwiftUI
//
//  Created by Zeeshan Suleman on 03/03/2023.
//

import SwiftUI
import FirebaseAuth

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case favorite
    case profile
    
    var title: String{
        switch self {
        case .home:
            return ""
        case .favorite:
            return ""
        case .profile:
            return ""
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "home-icon"
        case .favorite:
            return "favorite-icon"

        case .profile:
            return "profile-icon"
        }
    }
}

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                StartView()
                    .tag(0)

                if Auth.auth().currentUser?.uid != nil {
                    
                    WishListView(tabSelection: $selectedTab)
                        .tag(1)
                    
                } else {
                    loggedOutView()
                        .tag(1)
                }
                    
                SettingsView()
                    .tag(2)
            }
            .background(Color.clear)
            
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(width: 300, height: 90)
            .background(Color("NavBarBGColor"))
            .cornerRadius(60)
            .padding(.horizontal, 26)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(alignment: .center) {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 25, height: 25)
                .padding()
        }
        .clipShape(Circle())
        .frame(width: 90, height: 80)
        .background(isActive ? Color.accentColor : .clear)
        .cornerRadius(40)
    }
}
