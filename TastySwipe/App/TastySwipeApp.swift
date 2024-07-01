//
//  TastySwipeApp.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/03/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
//import RevenueCat
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
    @StateObject var tabBarManager = TabManager()
    @State var selection = 0
    
    var body: some Scene {
        WindowGroup {
          
                MainTabbedView()
                .environmentObject(tabBarManager)
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
                .preferredColorScheme(.dark)
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
            
                    .onChange(of: sessionManager.currentUser, { oldValue, newValue in
                        if newValue != nil {
                            wishlistViewModel.createWishListObserver()
                        } else {
                            wishlistViewModel.removeWishListObserver()
                        }
                    })
            
                  
            
        }
    }
    
    
    init() {
//        Purchases.logLevel = .debug
//        Purchases.configure(withAPIKey: "appl_CvgGNQYNduWDdNSUdgCZBXyajCN")
    }
    
}
