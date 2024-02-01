////
////  MainView.swift
////  TastySwipe
////
////  Created by Nursultan Yelemessov on 31/12/2023.
////
//
//import SwiftUI
//import CardStack
//
//struct MainView: View {
//    var body: some View {
//        
//        @State var mapState = MapViewState.noInput
//        @StateObject var viewModel = HomeViewModel()
//        
//        
//        ZStack(alignment: .center) {
//            
//            MenuActionButton(mapState: $mapState)
//            
//            ZStack(alignment: .top) {
//                
//                //MARK: - MapView
//                ExploreMapViewRepresentable(mapState: $mapState)
//                    .ignoresSafeArea()
//                
//                
//                //MARK: - Search View Appear and dissapear
//                if mapState == .searchingForLocation {
//                    LocationSearchView(mapState: $mapState)
//                } else if mapState == .noInput {
//                    LocationSearchActivationView()
//                    //                                .padding(.leading, 40)
//                        .padding(.top, -90)
//                        .onTapGesture {
//                            withAnimation(.spring()) {
//                                mapState = .searchingForLocation
//                            }
//                        }
//                }
//                //                //MARK: - Menu Button
//                //                MenuActionButton(mapState: $mapState)
//                //                    .padding(.leading)
//                //                    .padding(.top,4)
//                
//            }
//            
//            if mapState == .noInput {
////                    CardMain(cardViews: $viewModel.cardViews)
//                VStack {
//                    Spacer()
//                    CardStack(
//                      direction: LeftRight.direction,
//                      data: viewModel.cardViews,
//                      onSwipe: { card, direction in
//                          print("Swiped \(card.title) to \(direction)")
//                      },
//                      content: { place, _, _ in
//                          CardView(title: place.title, location: place.location, image: place.image, category: place.category, distance: place.distance, rating: place.rating)
//                      }
//                    )
//                    .environment(
//                      \.cardStackConfiguration,
//                      CardStackConfiguration(
//                        maxVisibleCards: 2,
//                        swipeThreshold: 0.1,
//                        cardOffset: 0,
//                        cardScale: 0.2,
//                        animation: .linear
//                      )
//                    )
//                    
//                    
//                    
////                        CardStack(
////                            direction: LeftRight.direction,
////                            data: viewModel.cardViews,
////                            onSwipe: { card, direction in
////
////                            },
////                            content: { place, _, _ in
////                                CardView(title: place.title, location: place.location, image: place.image, category: place.category, distance: place.distance, rating: place.rating)
////                            }
////                        )
//                    .scaledToFit()
//                    .frame(width: 240, alignment: .center)
//                    .padding(.bottom,200)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    MainView()
//}
