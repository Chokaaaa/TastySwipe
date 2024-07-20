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
    
//    @State var selectedTab = 0
    @EnvironmentObject var tabManager : TabManager
    @AppStorage("isOnboarding") var isOnboarding : Bool = true
    
    var body: some View {
        
        ZStack(alignment: .bottom){
                        if tabManager.showHiddenTab && !isOnboarding {
                            ZStack{
                                HStack{
                                    ForEach((TabbedItems.allCases), id: \.self){ item in
                                        Button{
                                            tabManager.selectedTab = item.rawValue
                                        } label: {
                                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (tabManager.selectedTab == item.rawValue))
                                        }
                                    }
                                }
                                .padding(6)
                                if isOnboarding {
                                    Color.black.ignoresSafeArea(edges: .all)
                                        .opacity(0.7)
                                }
            //                    VisualEffectBlur(blurStyle: .systemThinMaterialDark)
            //                        .ignoresSafeArea()
                            }
                            .frame(width: 300, height: 90)
                            .background(Color("NavBarBGColor"))
                            .cornerRadius(60)
                            .padding(.horizontal, 26)
                        }
            
            
            if tabManager.selectedTab == 0 {
                ZStack {
                    if tabManager.showHiddenTab {
                        VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                            .ignoresSafeArea()
                    }
                    StartView()
                        .tag(0)
                }
            } else if tabManager.selectedTab == 1 {
                
                if Auth.auth().currentUser?.uid != nil {
                    
                    WishListView(tabSelection: $tabManager.selectedTab)
                        .tag(1)
                    
                } else {
                    loggedOutView()
                        .tag(1)
                }
                
            } else if tabManager.selectedTab == 2 {
                
                PlacesListView()
                    .tag(2)
            }

            if !tabManager.showHiddenTab && !isOnboarding {
                ZStack{
                    HStack{
                        ForEach((TabbedItems.allCases), id: \.self){ item in
                            Button{
                                print("new selection \(item.rawValue)")
                                tabManager.selectedTab = item.rawValue
                            } label: {
                                CustomTabItem(imageName: item.iconName, title: item.title, isActive: (tabManager.selectedTab == item.rawValue))
                            }
                        }
                    }
                    .padding(6)
                    if isOnboarding {
                        Color.black.ignoresSafeArea(edges: .all)
                            .opacity(0.7)
                    }
                }
                .frame(width: 300, height: 90)
                .background(Color("NavBarBGColor"))
                .cornerRadius(60)
                .padding(.horizontal, 26)
            }
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
