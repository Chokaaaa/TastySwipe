//
//  TastySwipeApp.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/03/2023.
//

import SwiftUI
import Firebase
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

      GMSPlacesClient.provideAPIKey("AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")
      
    return true
  }
}

@main
struct TastySwipeApp: App {
    @StateObject var locationViewModel = LocationSearchViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isOnboarding") var isOnboarding = true
    var body: some Scene {
        WindowGroup {
//            LoginView()
            if isOnboarding {
                OnBoardingScreen()
                    .environmentObject(authViewModel)
            } else {
                HomeVIew()
                    .environmentObject(locationViewModel)
                    .environmentObject(authViewModel)
            }

        }
    }
}
