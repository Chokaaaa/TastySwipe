//
//  HomeVIew.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 08/03/2023.
//

import SwiftUI
import GooglePlaces

struct HomeVIew: View {
    
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    private var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
    @StateObject var viewModel = HomeViewModel()
    @State var fetcher: GMSAutocompleteFetcher?
    private var searchPredictions = [GMSAutocompletePrediction]()
    
//    init() {
//        UITabBar.appearance().isTranslucent = false
//    }
    
    
    
    var body: some View {
        
        TabView {
            ZStack(alignment: .center) {
                
                MenuActionButton(mapState: $mapState)
                
                ZStack(alignment: .top) {
                    
                    //MARK: - MapView
                    ExploreMapViewRepresentable(mapState: $mapState)
                        .ignoresSafeArea()
                    
                    
                    //MARK: - Search View Appear and dissapear
                    if mapState == .searchingForLocation {
                        LocationSearchView(mapState: $mapState)
                    } else if mapState == .noInput {
                        LocationSearchActivationView()
                        //                                .padding(.leading, 40)
                            .padding(.top, -90)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    mapState = .searchingForLocation
                                }
                            }
                    }
                    //                //MARK: - Menu Button
                    //                MenuActionButton(mapState: $mapState)
                    //                    .padding(.leading)
                    //                    .padding(.top,4)
                    
                }
                
                
                if mapState == .noInput {
                    CardMain(cardViews: $viewModel.cardViews)
                        .padding(.top, 310)
                }
            }
            .tabItem {
                Image("homeTab")
                Text("Home")
            }
            //MARK: - End of tab 1
            
            
            //MARK: - Create an if statement to check if the user is logged in and if he is nto show a loggedOutView
            
            loggedOutView()
                           .tabItem {
                               Image("heartTab")
                               Text("Wishlist")
                           }
            //MARK: - End of tab 2
                       
            SettingsView()
                           .tabItem {
                               Image("profileTab")
                               Text("Profile")
                           }
            //MARK: - End of tab 3
            
        }
        .onAppear {
                        // correct the transparency bug for Tab bars
                        let tabBarAppearance = UITabBarAppearance()
                        tabBarAppearance.configureWithOpaqueBackground()
                        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                        // correct the transparency bug for Navigation bars
                        let navigationBarAppearance = UINavigationBarAppearance()
                        navigationBarAppearance.configureWithOpaqueBackground()
                        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
            
//            let placeFields: GMSPlaceField = [.name, .formattedAddress]
//                placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
//                
//
//                  guard error == nil else {
//                    print("Current place error: \(error?.localizedDescription ?? "")")
//                    return
//                  }
//                    
//                    if let placeLikelihoodList = placeLikelihoods {
//                        for likelihood in placeLikelihoodList {
//                          let place = likelihood.place
//                          print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
//                          print("Current PlaceID \(String(describing: place.placeID))")
//                        }
//                      }
//                    
//                    
//                }
                    }
//        .accentColor()
        
        
        //MARK: - Identify user locaiton on home view
        .background(Color.black)
        .onReceive(LocationManager.shared.$userLcoation) { location in
            if let locaiton = location {
                print("DEBUG: user location in home view is \(location)")
                locationViewModel.userLocation = location
            }
        }
    }
    
   
    
}

struct HomeVIew_Previews: PreviewProvider {
    static var previews: some View {
        HomeVIew()
    }
}
