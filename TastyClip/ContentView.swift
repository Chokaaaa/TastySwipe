//
//  ContentView.swift
//  TastyClip
//
//  Created by Nursultan Yelemessov on 16/01/2024.
//

import SwiftUI
import Firebase
//import FirebaseAuth
import FirebaseFirestore
//import StarRatingViewSwiftUI

struct ContentView: View {
    
//    let title : String
//    let location : String
//    let image : String
//    let category : String
//    let distance : Int
//    let rating : Double
//    let id : String
//    let latitude : Double
//    let longitude : Double
    
    @State private var showingLoginView = false
    @State private var isLoading = false
    @State var voting : String?
    
    var body: some View {
        
        VStack {
            Text("App Clip Loading...")
        }
        .fullScreenCover(item: $voting) { voting in
            
            VotingView(votingId: voting)
                        
        }
        
        .onContinueUserActivity(
                        NSUserActivityTypeBrowsingWeb,
                        perform: handleUserActivity
                    )
        
                //MARK: - Not Sure what is this
//                .userActivity(NSUserActivityTypeBrowsingWeb) { activity in
//                    
//                }
        }
    
    func handleUserActivity(_ userActivity: NSUserActivity) {
            guard
                let incomingURL = userActivity.webpageURL,
                let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems,
                let id = queryItems.first(where: { $0.name == "votingId" })?.value
            else {
                voting = nil
                print("voting is nil")
                return
            }
        voting = id
        print("Did recieve Url")
        
        
      
    }
    
    }


#Preview {
    ContentView()
}
