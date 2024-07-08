//
//  PlacesListView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 04/01/2024.
//

import SwiftUI
import RevenueCat
import RevenueCatUI
import StarRatingViewSwiftUI
import SwiftData

struct PlacesListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var purchasesManager : PurchasesManager
    @EnvironmentObject var cardsManager : CardsManager
    @StateObject var viewModel = PlacesListViewModel()
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Environment(\.modelContext) private var context
    @EnvironmentObject var tabManager : TabManager
    @Query var preferedPlaces : [PreferedPlaceModel]
    @State private var isShowingPayWall = false
//    @State private var selectedRating:
    @State private var selectedRating = 4
    
    @State var showPlacesSettings = false
    @AppStorage("filterByRating") var filterByRating = 3
    @AppStorage("searchRadius") var searchRadius = 1000
      let rate = [3, 4, 5]
    
    let columns : [GridItem] = [GridItem(.flexible()), GridItem(.flexible(), spacing: 10)]
    
    
    
    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
        
            VStack {
                HStack(spacing: 90) {
                    
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
                        
                        VStack {
                            
                            Image("")
                                .resizable()
                                .foregroundStyle(Color.accentColor)
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.clear)
                        .background(Color.clear, in: Circle())
                    }
                    
                    
                    //MARK: - Text
                    
                    Text("Places")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    
                    
                    
                    //MARK: - Profile Icon
                    
                    Button {
                        showPlacesSettings.toggle()
                    } label: {
                        VStack {
                            
                            Image("configureLineCirclesIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            
                            
                        }
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.black.opacity(0.8))
                        //                            .background(.ultraThinMaterial, in: Circle())
                        .background(Color("NavBarBGColor"), in: Circle())
                    }
                    .sheet(isPresented: $showPlacesSettings, content: {
                        PlacesSetingsView()
//                            .presentationDetents([.medium])
                            .presentationDetents([.height(550)])
                    })
                    
                }
                
                ScrollView {
                    
                    VStack(alignment: .leading,spacing: 10) {
                        //                    Text("Place & Rating")
                        //                        .font(.largeTitle)
                        //                        .fontWeight(.bold)
                        //                        .tint(.accentColor)
                        //
                        //                    VStack {
                        //                        Text("Please select your place and rating")
                        //                            .foregroundStyle(Color.gray)
                        //                            .multilineTextAlignment(.leading)
                        //
                        //                    }
                        //                    .font(.body)
                        //                    .foregroundStyle(Color.blue)
                        //
                        //
                        //
                        //                        Picker("", selection: $selectedRating) {
                        //                            ForEach(rate, id: \.self) { number in
                        //                                    Text("\(number)")
                        //                            }
                        //                        }
                        //                        .pickerStyle(.segmented)
                        
                        
                        LazyVGrid(columns: columns) {
                            
                            ForEach(Array(TagModel.allCases.enumerated()), id: \.1) { index, tag in
                                Button(action: {
                                    viewModel.tagSelected(tag: tag)
                                }, label: {
                                    
                                    
                                    VStack(spacing: 10) {
                                        Image(tag.emoji)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60, alignment: .center)
                                        
                                        Text(tag.title)
                                            .fontWeight(.medium)
                                            .font(.system(size: 13))
//                                            .foregroundStyle(!viewModel.selectedTags.contains(tag) ? Color("SystemTextColor") : Color.black)
                                            .foregroundStyle(Color("SystemTextColor"))
                                        //                                        .foregroundStyle(!viewModel.selectedTags.contains(tag) ? Color("SystemTextColor") : Color("SystemTextColor"))
                                        
                                    }
                                    .frame(width: 130, height: 120)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(getStatusColor(tag: tag, index: index))
                                        
                                    )
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(viewModel.selectedTags.contains(tag) ? Color.accentColor : Color.clear, lineWidth: 1.0)
                                    }
                                })
                                
                                .disabled(disableButton(index: index))
                                
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical)
                        
                    }
                    .padding()
                    
                    HStack {
                        Text("We continuously supplement our category selection.")
                            .font(.caption2)
                            .underline()
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.bottom)
                    
                    //                VStack(alignment: .leading) {
                    
                    //                    Text("Rating: ")
                    //                        .font(.title)
                    
                    //                    HStack {
                    //                        StarRatingView(rating: 4, color: Color.yellow, maxRating: 5)
                    //                            .frame(width: 220, height: 35, alignment: .leading)
                    //
                    //                        Text(String(format: "%.1f", 4.000))
                    //                            .font(.title)
                    //                            .foregroundStyle(.yellow)
                    //                    }
                    
                    //                }
                    
                    .padding(.bottom, 100)
                }
                
                .scrollIndicators(.hidden)
            }
            .fullScreenCover(isPresented: $isShowingPayWall) {
                PaywallView()
                    .padding([.leading, .trailing], -100)
//                                .paywallFooter(condensed: false)
            }

        
//        }
        
        
        .onDisappear(perform: {
            print("did change selection \(tabManager.selectedTab)")
            if tabManager.selectedTab == 0 {
                if preferedPlaces.count > 0 {
                    for preferedPlace in preferedPlaces {
                        context.delete(preferedPlace)
                    }
                }
                for tag in viewModel.selectedTags {
                    let newPreferedPlace = PreferedPlaceModel(place: tag)
                    context.insert(newPreferedPlace)
                }
                let locationName = viewModel.selectedTags.map({ $0.apiName }).joined(separator: " OR ")
                homeViewModel.fetchPlaces(locationName: locationName, filterByRating: filterByRating, searchRadius: searchRadius)
                cardsManager.showLastCard = false
                cardsManager.totalCardSwiped = 0
                
            }
        })
        
        .onAppear {
            viewModel.selectedTags = preferedPlaces.map { $0.place }
            if viewModel.selectedTags.count == 0 {
                viewModel.tagSelected(tag: .cafe)
            }
//            selectedRating = filterByRating
        }
        
//        .toolbar {
//            
//            ToolbarItem(placement: .topBarTrailing) {
//                
//                HStack {
//                    if purchasesManager.isSubscriptionActive == false {
//                        Button {
//                            isShowingPayWall = true
//                        } label: {
//                            HStack(spacing: 0) {
//                                Text("💎")
//                                    .foregroundStyle(Color.yellow)
//                                    .frame(width: 25, height: 0)
//                                Text("PRO")
//                                    .fontWeight(.bold)
//                            }
//                            .padding(5)
//                            .foregroundColor(.white)
//                            .background(Color.accentColor)
//                            .clipShape(
//                                Capsule()
//                            )
//                        }
//                    } else {
//                        
//                    }
//                    
//                    Button {
//                        if preferedPlaces.count > 0 {
//                            for preferedPlace in preferedPlaces {
//                                context.delete(preferedPlace)
//                            }
//                        }
//                        for tag in viewModel.selectedTags {
//                            let newPreferedPlace = PreferedPlaceModel(place: tag)
//                            context.insert(newPreferedPlace)
//                        }
//                        let locationName = viewModel.selectedTags.map({ $0.apiName }).joined(separator: " OR ")
//                        homeViewModel.fetchPlaces(locationName: locationName, filterByRating: selectedRating)
//                        cardsManager.showLastCard = false
//                        cardsManager.totalCardSwiped = 0
//                        self.presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text(homeViewModel.isFetching ? "Fetching..." : "Save")
//                    }
//                    .disabled(homeViewModel.isFetching)
//                }
//            }
//        }
        
    }
    func getStatusColor(tag: TagModel, index: Int) -> Color {
        if !purchasesManager.isSubscriptionActive {
            if index > 2 {
                return Color.gray.opacity(0.15)
            }
//            return viewModel.selectedTags.contains(tag) ? Color.accentColor : Color("PlacesSystemColor")
            return viewModel.selectedTags.contains(tag) ? Color.accentColor.opacity(0.2) : Color("PlaceNewDarkColor").opacity(0.7)
            
        }
//        return viewModel.selectedTags.contains(tag) ? Color.accentColor : Color("PlacesSystemColor")
        return viewModel.selectedTags.contains(tag) ? Color.accentColor.opacity(0.2) : Color("PlaceNewDarkColor").opacity(0.7)
    }
    
    func disableButton(index: Int) -> Bool {
        if !purchasesManager.isSubscriptionActive {
            if index > 2 {
                return true
            }
            return false
        }
        return false
    }
    
}

#Preview {
    PlacesListView()
        .environmentObject(HomeViewModel())
        .environmentObject(PurchasesManager())
}
