//
//  TastySwipeApp.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/03/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import RevenueCat
import SwiftData
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
      GADMobileAds.sharedInstance().start(completionHandler: nil)
      
//      GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers =
//          [ "2077ef9a63d2b398840261c8221a0c9b" ] // Sample device ID
      
      
    return true
  }
}

@main
struct TastySwipeApp: App {
    @AppStorage("appTheme") var isDarkModeOn = false
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var csManager = ColorSchemeManager()
    @StateObject var purchasesManager = PurchasesManager()
    @StateObject var sessionManager = SessionManager()
    @StateObject var cardsManager = CardsManager()
    @StateObject var wishlistViewModel = WishListViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isOnboarding") var isOnboarding = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selection = 0
    
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnBoardingScreen()
                    .environmentObject(authViewModel)
                    .environmentObject(sessionManager)
            } else {
                MainTabbedView()
//                TabView(selection: $selection) {
//                 StartView()
//                    .tabItem {
//                        
//                        if selection == 0 {
//                            Image(systemName: "location.fill")
//                                .environment(\.symbolVariants, .none)
//                        } else {
//                            Image(systemName: "location")
//                                .environment(\.symbolVariants, .none)
//
//                        }
//                        Text("Places")
//                    }
//                    .tag(0)
//                    if Auth.auth().currentUser?.uid != nil {
//                        WishListView(tabSelection: $selection)
//                            .tabItem {
//                                
//                                if selection == 1 {
//                                    Image(systemName: "star.fill")
//                                        .environment(\.symbolVariants, .none)
//                                } else {
//                                    Image(systemName: "star")
//                                        .environment(\.symbolVariants, .none)
//
//                                }
//                                Text("Wishlist")
//                            }
//                            .tag(1)
//                    }else{
//                        loggedOutView()
//                            .tabItem {
//                                if selection == 1 {
//                                    Image(systemName: "star.fill")
//                                        .environment(\.symbolVariants, .none)
//                                } else {
//                                    Image(systemName: "star")
//                                        .environment(\.symbolVariants, .none)
//
//                                }
//                                Text("Wishlist")
//                            }
//                            .tag(1)
//                    }
//                    
//                    SettingsView()
//                        .tabItem {
//                            if selection == 2 {
//                                Image(systemName: "person.fill")
//                                    .environment(\.symbolVariants, .none)
//                            } else {
//                                Image(systemName: "person")
//                                    .environment(\.symbolVariants, .none)
//                            }
//                            Text("Profile")
//                        }
//                        .tag(2)
//                }
                
                .environmentObject(cardsManager)
                .environmentObject(sessionManager)
                .environmentObject(wishlistViewModel)
//                .onAppear {
//                    let tabBarAppearance = UITabBarAppearance()
//                    tabBarAppearance.configureWithOpaqueBackground()
//                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
//                    let navigationBarAppearance = UINavigationBarAppearance()
//                    navigationBarAppearance.configureWithOpaqueBackground()
//                    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//                    
//                }
                .background(Color.black)
                    .environmentObject(locationViewModel)
                    .environmentObject(authViewModel)
                    .environmentObject(homeViewModel)
                    .environmentObject(csManager)
                    .environmentObject(purchasesManager)
                    .modelContainer(for: [
                    
                        PreferedPlaceModel.self
                        
                    ])
                    .onAppear {
                         UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                        csManager.applyColorScheme()
                    }
                    .onChangeOf(sessionManager.currentUser) { newValue in
                        if newValue != nil {
                            wishlistViewModel.createWishListObserver()
                        } else {
                            wishlistViewModel.removeWishListObserver()
                        }
                    }
            }
        }
    }
    
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_CvgGNQYNduWDdNSUdgCZBXyajCN")
    }
    
}
