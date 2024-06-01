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
import MapKit


struct MapAnnotationInfo : Identifiable {
    let id = UUID()
    let location : CLLocationCoordinate2D
}


struct StartView: View {
    let mapView = ExploreMapView()
    @State private var showingLoginView = false
    @State private var mapState = MapViewState.noInput
    @State private var isShowingPayWall = false
    @Query var preferedPlaces : [PreferedPlaceModel]
    @State private var timer = Timer.publish(every: 8, on: .main, in: .common)
    @State var interstitial : GADInterstitialAd?
    @State var rotateentire  = false
    @State private var leftSwipeCount = 0
    @State private var rightSwipeCount = 0
    @State private var location: CLLocationCoordinate2D?
    @State private var position: MapCameraPosition = .automatic
    @State private var mapAnnotations : [MapAnnotationInfo] = []
    @State private var region : MKCoordinateRegion?
    @State private var didFetchLocation = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var wishListViewModel: WishListViewModel
    @EnvironmentObject var cardsManager: CardsManager
    @EnvironmentObject var purchasesManager : PurchasesManager
    
    @AppStorage("swipeAlertPresented") var swipeAlertPresented = 0
    
    
    //MARK: - Animation pulse
    @State var isAnimating: Bool = true
    let timing: Double
    let maxCounter = 3
    
    let frame: CGSize
    let primaryColor: Color
    
    init(color: Color = .white, size: CGFloat = 180, speed: Double = 0.5) {
        timing = speed * 2
        frame = CGSize(width: size, height: size)
        primaryColor = color
    }
    
    private let swipeThreshold = 10
    
    
    var body: some View {
//        NavigationStack {
        
        ZStack(alignment: .center) {
            
            Color.black.ignoresSafeArea(edges: .all)
            
            VStack {
                
                HStack(spacing: 60) {
                    
                    //MARK: - Profile Icon
                        
                        Button {
                            
                        } label: {
                            VStack {
                                
                                Image("userIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                
                                
                            }
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.black.opacity(0.8))
//                            .background(.ultraThinMaterial, in: Circle())
                            .background(Color("NavBarBGColor"), in: Circle())
                        }


                    //MARK: - Text
                    
                    Text("Locale Link")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    
                    
                    //MARK: - AI Button
                    
                    Button {
                        
                    } label: {
                        VStack {
                            
                            Image("starsIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.black.opacity(0.8))
                        .background(Color("NavBarBGColor"), in: Circle())
                    }
                    
                    
                }
                
                
                //MARK: - Check it out
                //                MenuActionButton(mapState: $mapState)
                
                //                ZStack(alignment: .top) {
                //
                //                    Map(position: $position) {
                //
                //                        ForEach(mapAnnotations) { mapAnnotation in
                //
                //                            Annotation("Me", coordinate: mapAnnotation.location) {
                //
                //                                ZStack {
                //
                ////                                    ForEach(0..<maxCounter) { index in
                ////                                        Circle()
                ////                                            .stroke(
                ////
                ////                                                primaryColor.opacity(isAnimating ? 0.0 : 0.1),
                ////                                                style: StrokeStyle(lineWidth: isAnimating ? 0.0 : 10.0))
                ////                                            .scaleEffect(isAnimating ? 1.0 : 0.0)
                ////
                ////
                ////
                ////                                            .animation(
                ////                                                Animation.easeOut(duration: timing)
                ////                                                    .repeatForever(autoreverses: false)
                ////                                                    .delay(Double(index) * timing / Double(maxCounter))
                ////                                                )
                ////
                ////                                    }
                //
                //                                    if viewModel.cardViews.count == 0 {
                //
                //                                        PulseAnimation(imageName: "person.crop.circle.dashed.circle.fill", animationDuration: 4)
                //
                //                                    } else {
                //
                //                                        Image(systemName: "person.crop.circle.dashed.circle.fill" )
                //                                            .resizable()
                //                                            .scaledToFit()
                //                                            .frame(width: 30, height: 30)
                //                                            .font(.headline)
                //                                            .foregroundStyle(.white)
                //                                            .padding(6)
                //                                            .background(Color.accentColor)
                //                                            .cornerRadius(36)
                //                                    }
                //
                //
                //                                }
                //
                //                                .frame(width: frame.width, height: frame.height, alignment: .center)
                //                            }
                //                        }
                //
                //                    }
                //
                //                }
                
                
                
                
                //MARK: - Card View
                VStack {
                    Spacer()
                    
                    //MARK: - Removed Loading
                    if viewModel.cardViews.count == 0 {
                        
                        EmptyCardView()
                            .scaledToFit()
                            .frame(width: 350, alignment: .center)
                            .padding(.bottom,70)
                    } else {
                        if cardsManager.showLastCard {
                            LastCardView()
                            
                                .scaledToFit()
                                .frame(width: 350, alignment: .center)
                                .padding(.bottom,70)
                        } else {
                            CardStack(
                                direction: LeftRight.direction,
                                data: viewModel.cardViews,
                                onSwipe: { card, direction in
                                    print("Swiped \(card.title) to \(direction)")
                                    viewModel.activeCard = card
                                    cardsManager.totalCardSwiped += 1
                                    if direction == .left {
                                        haptic(.success)
                                        if purchasesManager.isSubscriptionActive == false {
                                            leftSwipeCount += 1
                                            print("Left swipes: \(leftSwipeCount)")
                                            checkAndShowAd()
                                            
                                        } else {
                                            
                                        }
                                    }
                                    
                                    if direction == .right {
                                        haptic(.success)
                                        if purchasesManager.isSubscriptionActive == false {
                                            
                                            rightSwipeCount += 1
                                            print("Right swipes: \(rightSwipeCount)")
                                            checkAndShowAd()
                                            
                                        } else {
                                            
                                        }
                                    }
                                    if cardsManager.totalCardSwiped == viewModel.cardViews.count {
                                        cardsManager.showLastCard = true
                                    }
                                },
                                content: { place, _, _ in
                                    CardView(title: place.title, location: place.location, image: place.image, category: place.category, distance: place.distance, rating: place.rating, id: place.id, latitude: place.latitude,longitude: place.longitude)
                                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9 * 1.3)
                                        .onTapGesture {
                                            haptic(.error)
                                            print("Did tapped card \(swipeAlertPresented)")
                                            if swipeAlertPresented < 2 {
                                                print("Should show alert")
                                                swipeAlertPresented += 1
                                                alertTitle = "Oh-Oh"
                                                alertMessage = "Please Swipe Left 👈🏽 or Swipe Right 👉🏽 to find the nearest place"
                                                showAlert = true
                                            }
                                        }
                                }
                                
                                
                            )
                            .environment(
                                \.cardStackConfiguration,
//                                 CardStackConfiguration(
//                                    maxVisibleCards: 2,
//                                    swipeThreshold: 0.1,
//                                    cardOffset: 0,
//                                    cardScale: 0.2,
//                                    animation: .linear
//                                 )
                                 
                                 CardStackConfiguration(
                                   maxVisibleCards: 3,
                                   swipeThreshold: 0.1,
                                   cardOffset: 10,
                                   cardScale: 0.2,
                                   animation: .linear
                                 )
                            )
                            .scaledToFit()
                            .frame(width: 350, alignment: .center)
                            .padding(.bottom,100)
                        }
                    }
                    Spacer()
                }
                .onAppear {
                    loadInterstitialAds()
                }
                
                
                
                //removed loading
//                if viewModel.cardViews.count == 0 {
//                    
//                    
//                    //                    Color.clear.ignoresSafeArea().background(
//                    //
//                    //                        .ultraThinMaterial
//                    //
//                    //                    )
//                    //                    VStack(alignment: .center, spacing: 15) {
//                    //
//                    //                        Text("Loading...")
//                    //
//                    //                       ProgressView()
//                    //                    }
//                }
                
            }
        }
//            .if(viewModel.cardViews.count == 0) { view in
//                
//            }
//            .navigationTitle("LocaleLink")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    
//                    
//                    NavigationLink(destination: PlacesListView()) {
//                        
//                        
//                        Image(systemName: "square.grid.2x2")
//                            .foregroundStyle(Color.accentColor)
//                        
//                    }
//                    
//                    
//                }
//                //MARK: - Need to reverse the changes here
//                ToolbarItem(placement: .topBarTrailing) {
//                    
//                    HStack {
//                        if purchasesManager.isSubscriptionActive == false {
//                            Button {
//                                isShowingPayWall = true
//                            } label: {
//                                HStack(spacing: 0) {
//                                    Text("💎")
//                                        .foregroundStyle(Color.yellow)
//                                        .frame(width: 25, height: 0)
//                                    Text("PRO")
//                                        .fontWeight(.bold)
//                                }
//                                .padding(5)
//                                .foregroundColor(.white)
//                                .background(Color.accentColor)
//                                .clipShape(
//                                    Capsule()
//                                )
//                            }
//                            .fullScreenCover(isPresented: $isShowingPayWall) {
//                                PaywallView()
//                                    .padding([.leading, .trailing], -100)
//                                //                                    .paywallFooter(condensed: false)
//                            }
//                        } else {
//                            
//                        }
//                        
//                        
//                        //MARK: - APP CLIP
//                        
//                        Button {
//                            if let currentUserId = Auth.auth().currentUser?.uid {
//                            guard let activeCard = viewModel.activeCard else { return }
//                            guard let hostUserId = Auth.auth().currentUser?.uid else { return }
//                            let votingReference = Firestore.firestore().collection("voting").document()
//                            let votingId = votingReference.documentID
//                            votingReference.setData([
//                                "title" : activeCard.title,
//                                "address" : activeCard.location,
//                                "image" : activeCard.image,
//                                "hostUserId" : hostUserId
//                            ])
//                            shareButton(votingId: votingId)
//                            } else {
//                                showingLoginView.toggle()
//                            }
//                            
//                                
//                        } label: {
//                            Image(systemName: "person.3")
//                                .foregroundStyle(Color.accentColor)
//                        }
//                        
//                        
//                    }
//                }
//            }
//        }
        
        //MARK: - Fullscreen Cover Sheet
        .fullScreenCover(isPresented: $viewModel.showNoLocationView, content: {
            NoLocationSharedView()
        })
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button {
                
            } label: {
                Text("Okay")
            }

        }, message: {
            Text(alertMessage)
        })
        .onReceive(LocationManager.shared.$userLcoation) { location in
            if let locaiton = location {
                print("DEBUG: user location in home view is \(location)")
                locationViewModel.userLocation = location
            }
        }
        .onReceive(timer, perform: { _ in
            
        })
        
        //MARK: - API CALL
        .onAppear(perform: {
            print("# did appear")
            //MARK: - Thats where the money spends :)
            if preferedPlaces.count != 0 {
                let locationName = preferedPlaces.map { $0.place.apiName }.joined(separator: " OR ")
                viewModel.locationName = locationName
            }
            
            
            if !didFetchLocation {
            
                didFetchLocation = true
                viewModel.fetchLocation { result in
                    print("# did fetch location")
                    switch result {
                    case .success(let value):
                        self.viewModel.showNoLocationView = false
                        mapAnnotations.append(MapAnnotationInfo(location: CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)))
                        
                        let center = CLLocationCoordinate2D(latitude: value.latitude - 0.0035, longitude: value.longitude)
                        
                        position = .region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)))
                        
                    case .failure(_):
                        self.viewModel.showNoLocationView = true
                        
                    }
                }
                
            }
            
                        
        })
        
        .fullScreenCover(isPresented: $showingLoginView) {
            LoginView()
        }
        
    }

    //appclips:tastyswipe-c8a3d.web.app

    //MARK: - SHARE BUTTON LOGIC
    func shareButton(votingId : String) {
            let url = URL(string: "https://tastyswipe-c8a3d.web.app?votingId=\(votingId)")
//                    let url = URL(string: "https://appclip.apple.com/id?=Chokaaaa.TastySwipe&votingId=\(votingId)")
            let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
    
    //MARK: - ADD by Google
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
               
               leftSwipeCount = 0
               rightSwipeCount = 0
               
           }
    }
    
    
}

#Preview {
    StartView()
        .environmentObject(HomeViewModel())
}


