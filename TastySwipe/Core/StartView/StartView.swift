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
import RevenueCat
import RevenueCatUI


struct MapAnnotationInfo : Identifiable {
    let id = UUID()
    let location : CLLocationCoordinate2D
}


struct StartView: View {
    let mapView = ExploreMapView()
    
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
    @State private var showDetail = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var selectedCardView : CardView?
    @State private var topDividerOffsetValue : CGFloat = 0
    @State private var imageOffsetValue : CGFloat = 0
    @State private var distanceOffsetValue : CGFloat = 0
    @State private var bottomOffsetValue: CGFloat = 0
    @State private var showBlur = false
    @StateObject var loginNavigationManager = LoginNavigationManager()
    @EnvironmentObject var locationViewModel : LocationSearchViewModel
    @EnvironmentObject var authViewModel : AuthViewModel
    @EnvironmentObject var viewModel : HomeViewModel
    @EnvironmentObject var wishListViewModel: WishListViewModel
    @EnvironmentObject var cardsManager: CardsManager
    @EnvironmentObject var purchasesManager : PurchasesManager
    @EnvironmentObject var tabManager : TabManager
    @AppStorage("isOnboarding") var isOnboarding : Bool = false
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
        
        NavigationStack {
            
            ZStack(alignment: .center) {
                
                Color.black.ignoresSafeArea()
                
                
                VStack {
                    if viewModel.showTopButtons {
                        HStack(spacing: 60) {
                            
                            //MARK: - Profile Icon
                            NavigationLink {
                                SettingsView()
                                //                                .statusBarHidden()
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
                            Text("Places Swipe")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                            
                            
                            //MARK: - AI Button
                            if purchasesManager.isSubscriptionActive == false {
                                Button {
                                    isShowingPayWall = true
                                } label: {
                                    VStack {
                                        
                                        Image("starsIcon")
                                            .resizable()
                                            .foregroundStyle(Color.accentColor)
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                        
                                        
                                    }
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(Color.black.opacity(0.8))
                                    .background(Color("NavBarBGColor"), in: Circle())
                                }
                            } else {
                                //MARK: - AI button
                                VStack {
                                    
                                    Image(systemName: "waveform.badge.mic")
                                        .resizable()
                                        .foregroundStyle(Color.accentColor)
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                    
                                    
                                }
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.clear)
                                //                                .background(Color.clear, in: Circle())
                                .background(Color("NavBarBGColor"), in: Circle())
                                
                            }
                        }
                    }
                    
                    //MARK: - Card View
                    VStack {
                        Spacer()
                        
                        //MARK: - Removed Loading
                        if viewModel.cardViews.count == 0 {
                            
                            EmptyCardView()
                                .scaledToFit()
                                .frame(width: 350, alignment: .center)
                                .padding(.bottom,70)
                        }
                        
                        
                        else {
                            if cardsManager.showLastCard {
                                LastCardView()
                                
                                    .scaledToFit()
                                    .frame(width: 350, alignment: .center)
                                    .padding(.bottom,70)
                            } else {
                                ZStack {
                                    if let place = selectedCardView {
                                        
                                        SplitCardView(title: place.title, location: place.location, image: place.image, category: place.category, distance: place.distance, rating: place.rating, id: place.id, latitude: place.latitude,longitude: place.longitude, topDividerOffsetValue: $topDividerOffsetValue, imageOffsetValue: $imageOffsetValue, distanceOffsetValue: $distanceOffsetValue, bottomOffsetValue: $bottomOffsetValue, selectedCardView: $selectedCardView, showTopButtons: $viewModel.showTopButtons)
                                            .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9 * 1.3)
                                            .transition(.customTransition)
                                    }
                                    
                                    HStack {
                                        Spacer()
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
                                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9 * 1.3, alignment: .center)
                                                    .onTapGesture {
                                                        haptic(.error)
                                                        
                                                        selectedCardView = place
                                                        tabManager.showHiddenTab = true
                                                        viewModel.showTopButtons = false
                                                        withAnimation(.easeInOut(duration: 0.2)) {
                                                            topDividerOffsetValue = -(UIScreen.main.bounds.width * 0.9 * 1.3 * 0.4) + 55
                                                            imageOffsetValue = -(UIScreen.main.bounds.width * 0.9 * 1.3 * 0.39) + 30
                                                            distanceOffsetValue = -(UIScreen.main.bounds.width * 0.9 * 1.3 * 0.39) + 50
                                                            bottomOffsetValue = 157.5
                                                        }
                                                        
                                                    }
                                            }
                                            
                                        )
                                        .environment(
                                            \.cardStackConfiguration,
                                             
                                             CardStackConfiguration(
                                                maxVisibleCards: 3,
                                                swipeThreshold: 0.1,
                                                cardOffset: 10,
                                                cardScale: 0.2,
                                                animation: .linear
                                             )
                                        )
                                        .scaledToFit()
                                        //.frame(width: 350, alignment: .center)
                                        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                                        .padding(.bottom,200)
                                        .opacity(selectedCardView == nil ? 1 : 0)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .onAppear {
                        loadInterstitialAds()
                    }
                    
                    
                }
         
                    .fullScreenCover(isPresented: $isShowingPayWall) {
                        PaywallView()
                            .padding([.leading, .trailing], -100)
                        //                                .paywallFooter(condensed: false)
                    }
                
                if isOnboarding {
                    
                    Color.black.ignoresSafeArea(edges: .all)
                        .opacity(0.7)
                    
                    VStack(alignment: .center) {
                        
                        Text("Swipe right or left to see the next place")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Image("tutorialCardView")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Got it!")
                                .background {
                                    Capsule()
                                        .frame(width: 80, height: 60)
                                }
                        }
                        
                        
                    }
                }
                
                }
            
            
            
            }
            
            
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
            
            //        .navigationDestination(isPresented: $loginNavigationManager.showLoginView, destination: {
            //            LoginView(loginNavigationManager: loginNavigationManager)
            //        })
            //
            .fullScreenCover(isPresented: $loginNavigationManager.showLoginView) {
                LoginView(loginNavigationManager: loginNavigationManager)
            }
            
            //        .fullScreenCover(isPresented: $showingLoginView) {
            //            LoginView()
            //        }
            
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
    
    
    
    extension AnyTransition {
        static var customTransition: AnyTransition {
            AnyTransition.modifier(
                active: CustomTransitionModifier(offset: UIScreen.main.bounds.height),
                identity: CustomTransitionModifier(offset: 0)
            )
        }
    }
    
    struct CustomTransitionModifier: ViewModifier, Animatable {
        var offset: CGFloat
        
        var animatableData: CGFloat {
            get { offset }
            set { offset = newValue }
        }
        
        func body(content: Content) -> some View {
            content
                .offset(y: offset)
        }
    }
