//
//  TastyClipApp.swift
//  TastyClip
//
//  Created by Nursultan Yelemessov on 16/01/2024.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      
    return true
  }
}

@main
struct TastyClipApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension String: Identifiable {
    public var id: String { self }
}
