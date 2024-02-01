//
//  TastySwipeApp.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/03/2023.
//

import SwiftUI
import Firebase
import GooglePlaces
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
      
      GMSPlacesClient.provideAPIKey("AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")
      
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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isOnboarding") var isOnboarding = true
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnBoardingScreen()
                    .environmentObject(authViewModel)
            } else {
                TabView {
                 StartView()
                    .tabItem {
                        Image(systemName: "house")
                            .environment(\.symbolVariants, .none)
                        Text("Home")
                    }
                    if Auth.auth().currentUser?.uid != nil {
                        WishListView()
                            .tabItem {
                                Image(systemName: "heart")
                                    .environment(\.symbolVariants, .none)
                                Text("Wishlist")
                            }
                    }else{
                        loggedOutView()
                            .tabItem {
                                Image(systemName: "heart")
                                    .environment(\.symbolVariants, .none)
                                Text("Wishlist")
                            }
                    }
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "person")
                                .environment(\.symbolVariants, .none)
                            Text("Profile")
                        }
                }
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithOpaqueBackground()
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    let navigationBarAppearance = UINavigationBarAppearance()
                    navigationBarAppearance.configureWithOpaqueBackground()
                    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
                    
                }
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
            }

        }
    }
    
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_CvgGNQYNduWDdNSUdgCZBXyajCN")
    }
    
}
