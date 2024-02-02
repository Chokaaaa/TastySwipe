//
//  StartView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 18/01/2024.
//

import SwiftUI
import CardStack
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftData
import GoogleMobileAds

struct StartView: View {
    
    @State private var showingLoginView = false
    @State private var mapState = MapViewState.noInput
    @State private var isShowingPayWall = false
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var viewModel : HomeViewModel
    @Query var preferedPlaces : [PreferedPlaceModel]
    @EnvironmentObject var purchasesManager : PurchasesManager
    @State private var timer = Timer.publish(every: 8, on: .main, in: .common)
    @State var interstitial : GADInterstitialAd?
    @State var rotateentire  = false
    @State private var leftSwipeCount = 0
    @State private var rightSwipeCount = 0
    private let swipeThreshold = 10
    
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                
                
                
                MenuActionButton(mapState: $mapState)
                
                ZStack(alignment: .top) {
                    
                    
                    
                    //MARK: - MapView
                    ExploreMapViewRepresentable(mapState: $mapState)
                        .ignoresSafeArea()
                    
                }
                
                VStack {
                    Spacer()
                   
                    
                    if viewModel.cardViews.count == 0 {
                        CardView(title: "Hello", location: "Loading location", image:"https://unsplash.com/photos/white-and-black-printer-paper-WyxqQpyFNk8", category: "Food", distance: 0, rating: 0.0, id: "0", latitude: 0, longitude: 0)
                            .scaledToFit()
                            .frame(width: 350, alignment: .center)
                            .padding(.bottom, 50)
                    } else {
                        CardStack(
                            direction: LeftRight.direction,
                            data: viewModel.cardViews,
                            onSwipe: { card, direction in
                                print("Swiped \(card.title) to \(direction)")
                                
//                                if let cardIndex = viewModel.cardViews.firstIndex(where: { $0.id == card.id }),
//                                   let currentLocation = viewModel.currentLocation {
//                                    
//                                    if cardIndex + 1 == viewModel.cardViews.count {
//                                        print("Did Find Last card")
//                                        viewModel.fetchPlaces(location: currentLocation)
//                                    }
//                                }
                                viewModel.activeCard = card
                                if direction == .left {
                                    leftSwipeCount += 1
                                    print("Left swipes: \(leftSwipeCount)")
                                    checkAndShowAd()
                                }
                                
                                if direction == .right {
                                    rightSwipeCount += 1
                                    print("Right swipes: \(rightSwipeCount)")
                                    checkAndShowAd()
                                }
                                
                            },
                            content: { place, _, _ in
                                CardView(title: place.title, location: place.location, image: place.image, category: place.category, distance: place.distance, rating: place.rating, id: place.id, latitude: place.latitude,longitude: place.longitude)
                            }
                            
                            
                        )
                        .environment(
                            \.cardStackConfiguration,
                             CardStackConfiguration(
                                maxVisibleCards: 2,
                                swipeThreshold: 0.1,
                                cardOffset: 0,
                                cardScale: 0.2,
                                animation: .linear
                             )
                        )
                        .scaledToFit()
                        .frame(width: 350, alignment: .center)
                        .padding(.bottom,100)
                    }
                    
                }
                .onAppear {
                    loadInterstitialAds()
                }
                
                if viewModel.cardViews.count == 0 {
                    Color.clear.ignoresSafeArea().background(
                        
                        .ultraThinMaterial
                    
                    )
                    VStack(alignment: .center, spacing: 15) {
    
                        Text("Loading...")
                        
                       ProgressView()
                    }
                }
                
            }
//            .if(viewModel.cardViews.count == 0) { view in
//                
//            }
            .navigationTitle("Tasty Swipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    
                    
                    NavigationLink(destination: PlacesListView()) {
                        
                        Image(systemName: "square.grid.2x2")
                            .foregroundStyle(Color.accentColor)
                        
                    }
                    
                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    HStack {
                        if purchasesManager.isSubscriptionActive == false {
                            Button {
                                isShowingPayWall = true
                            } label: {
                                HStack(spacing: 0) {
                                    Text("💎")
                                        .foregroundStyle(Color.yellow)
                                        .frame(width: 25, height: 0)
                                    Text("PRO")
                                        .fontWeight(.bold)
                                }
                                .padding(5)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(
                                    Capsule()
                                )
                            }
                            .fullScreenCover(isPresented: $isShowingPayWall) {
                                PaywallView()
                                    .padding([.leading, .trailing], -100)
                                //                                    .paywallFooter(condensed: false)
                            }
                        } else {
                            
                        }
                        
                        
                        //MARK: - APP CLIP
                        
                        Button {
                            if let currentUserId = Auth.auth().currentUser?.uid {
                            guard let activeCard = viewModel.activeCard else { return }
                            guard let hostUserId = Auth.auth().currentUser?.uid else { return }
                            let votingReference = Firestore.firestore().collection("voting").document()
                            let votingId = votingReference.documentID
                            votingReference.setData([
                                "title" : activeCard.title,
                                "address" : activeCard.location,
                                "image" : activeCard.image,
                                "hostUserId" : hostUserId
                            ])
                            shareButton(votingId: votingId)
                            } else {
                                showingLoginView.toggle()
                            }
                            
                                
                        } label: {
                            Image(systemName: "person.3")
                                .foregroundStyle(Color.accentColor)
                        }
                        
                        
                    }
                }
            }
        }
        .onReceive(LocationManager.shared.$userLcoation) { location in
            if let locaiton = location {
                print("DEBUG: user location in home view is \(location)")
                locationViewModel.userLocation = location
            }
        }
        .onReceive(timer, perform: { _ in
            
        })
        .onAppear(perform: {
            
            if preferedPlaces.count != 0 {
                let locationName = preferedPlaces.map { $0.place.apiName }.joined(separator: " OR ")
                viewModel.locationName = locationName
            }
            viewModel.fetchLocation()
            
        })
        
        .fullScreenCover(isPresented: $showingLoginView) {
            LoginView()
        }
        
    }

    //appclips:tastyswipe-c8a3d.web.app

    func shareButton(votingId : String) {
            let url = URL(string: "https://tastyswipe-c8a3d.web.app?votingId=\(votingId)")
//                    let url = URL(string: "https://appclip.apple.com/id?=Chokaaaa.TastySwipe&votingId=\(votingId)")
            let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
    
    func loadInterstitialAds() {
        
        let request = GADRequest()
        
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910",
//           GADInterstitialAd.load(withAdUnitID: "ca-app-pub-2127236424500505/9448869160",
                                       request: request,
                             completionHandler: { [self] ad, error in
                               if let error = error {
                                 print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                 return
                               }
                               interstitial = ad
                             }
           )
    }
    
    private func checkAndShowAd() {
           if leftSwipeCount >= swipeThreshold || rightSwipeCount >= swipeThreshold {
               
               if let interstitial = interstitial {
                   let root = UIApplication.shared.windows.first?.rootViewController
                   interstitial.present(fromRootViewController: root!)
               } else {
                   print("Add is not redy please try again later")
               }
           }
    }
    
}

#Preview {
    StartView()
        .environmentObject(HomeViewModel())
}
