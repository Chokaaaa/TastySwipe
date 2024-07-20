//
//  SplitCardView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 02/06/2024.
//

import SwiftUI
import StarRatingViewSwiftUI
import FirebaseAuth
import Firebase

struct SplitCardView: View {
    
    
    let title : String
    let location : String
    let image : String
    let category : String
    let distance : Int
    let rating : Double
    let id : String
    let latitude : Double
    let longitude : Double
    @State var shareURL : URL?
    @State private var showingLoginView = false
    @StateObject var loginNavigationManager = LoginNavigationManager()
    @Binding var topDividerOffsetValue : CGFloat
    @Binding var imageOffsetValue : CGFloat
    @Binding var distanceOffsetValue : CGFloat
    @Binding var bottomOffsetValue : CGFloat
    @Binding var selectedCardView : CardView?
    @Binding var showTopButtons: Bool
    @EnvironmentObject var tabManager : TabManager
    
    @EnvironmentObject var wishListViewModel: WishListViewModel
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isLoading = false
    private var isWishListed: Bool {
        return wishListViewModel.wishList.contains(where: { $0.id == id })
    }
    @State private var isLoadingWishlist = false
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                Capsule()
                    .frame(width: 40, height: 5, alignment: .center)
                    .foregroundStyle(.white)
                    .offset(y: topDividerOffsetValue)
                
                //MARK: - Image
                ZStack {
                    AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(image)&key=AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")) { phase in
                        switch phase {
                        case .empty:
                            Color.clear
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: (UIScreen.main.bounds.width * 0.9 * 1.3) - 50)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .clipped()
                            
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: (UIScreen.main.bounds.width * 0.9 * 1.3) - 50)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .clipped()
                            
                        case .failure:
                            Color.clear
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: (UIScreen.main.bounds.width * 0.9 * 1.3) - 50)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .clipped()
                            
                        @unknown default:
                            EmptyView()
                                .frame(width: 60, height: 60)
                        }
                    }
//                    .offset(y: -(UIScreen.main.bounds.width * 0.9 * 1.3 * 0.35))
                    .offset(y: imageOffsetValue)
                   
                    //MARK: - Distance marker in glass bg
                    VStack {
                        HStack {
                            HStack(spacing: 5) {
                                Image("paperPlane")
                                    .scaledToFit()
                                    .padding(.leading,5)
                                    .foregroundStyle(.white)
                                Text("\(distance) m")
                                    .font(.system(size: 15, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            //MARK: - Paperline
                            .padding(.vertical, 7)
                            .padding(.horizontal, 8)
                            .background(
                                .ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                            )
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading, 5)
                    .offset(y: distanceOffsetValue)
                    
                    //MARK: - BOX bottom
                    
                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 0) {
                            Group {
                                
                                HStack {
                                    Text(title)
                                        .lineLimit(1)
                                        .font(.system(size: 20, design: .rounded))
                                        .foregroundStyle(Color.white)
                                        .fontWeight(.bold)
                                        .padding(.top, 12)
                                    
                                    Spacer()
                                    
                                    Button {
                                        tabManager.showHiddenTab =  false
                                        showTopButtons = true
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            topDividerOffsetValue = 0
                                            imageOffsetValue = 0
                                            distanceOffsetValue = 0
                                            bottomOffsetValue = 0
                                        } completion: {
                                            selectedCardView = nil
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.white)
                                            .padding(.top, 12)
                                            .padding(.trailing, 10)
                                    }
                                }
                                
//                                //MARK: - Raiting
//                                StarRatingView(rating: Float(rating), color: Color("starsColor"), maxRating: 5)
//                                    .frame(width: 25, height: 20, alignment: .leading)
                                
                                HStack(spacing: 3) {
                                    ForEach(1...5, id: \.self) { index in
                                        StarType.getStarImage(value: rating, index: index)
                                    }
                                }
                                
                                
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(category) & more")
                                            .font(.system(size: 15, design: .rounded))
                                            .foregroundStyle(Color.white)
                                            .fontWeight(.bold)
                                        
                                        Text(location)
                                            .lineLimit(2)
                                            .font(.system(size: 16, design: .rounded))
                                            .foregroundColor(.white.opacity(0.9))
                                            .fontWeight(.regular)
                                    }
                                    
                                }
                                .padding(.top, 25)
                                .padding(.bottom)
                                if tabManager.showHiddenTab {
                                    Divider()
                                        .padding(.trailing, 10)
                                    
                                    //MARK: - Action Button
                                    
                                    HStack(alignment: .center, spacing: 15) {
//                                        Spacer()
                                        Button {
//                                            shareURL = getGoogleMapsShareLink(latitude: latitude, longitude: longitude)
                                            
                                            if let url = getGoogleMapsShareLink(latitude: latitude, longitude: longitude) {
                                                            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                                            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                            }
                                            
                                        } label: {
                                            Image("shareIconDetail")
                                            //                                            .font(.system(size: 25))
                                                .foregroundStyle(.white)
                                            
                                        }
                                        .padding()
                                        .frame(width: 90, height: 65)
                                        .background(Color.white.opacity(0.3))
                                        .cornerRadius(33)
                                        .shadow(color: .gray.opacity(0.5), radius: 5,x: 0,y: 0)
                                        
//                                        Spacer()
                                        
                                        Button {
                                            openGoogleMaps(latitude: latitude, longitude: longitude)
                                            
                                        } label: {
                                            Image("routingIconDetail")
                                            //                                            .font(.system(size: 25))
                                                .foregroundStyle(.white)
                                            
                                        }
                                        .padding()
                                        .frame(width: 90, height: 65)
                                        .background(Color.white.opacity(0.3))
                                        .cornerRadius(33)
                                        .shadow(color: .gray.opacity(0.5), radius: 5,x: 0,y: 0)
                                        
//                                        Spacer()
                                        
                                        Button {
                                            print("Did tapped button")
                                            guard let currentUserId = Auth.auth().currentUser?.uid else {
                                                loginNavigationManager.showLoginView = true
                                                return
                                            }
                                            print("User authenticated")
                                            if let index = wishListViewModel.wishList.firstIndex(where: { $0.id == id }) {
                                                wishListViewModel.wishList.remove(at: index)
                                                isLoadingWishlist = true
                                                Firestore.firestore().collection("users").document(currentUserId).collection("wishlist").document(id).delete { error in
                                                    isLoadingWishlist = false
                                                }
                                            } else {
                                                let wishListItem = WishListModel(title: title, location: location, image: image, category: category, rating: rating, id: id)
                                                wishListViewModel.wishList.append(wishListItem)
                                                isLoadingWishlist = true
                                                
                                                Firestore.firestore().collection("users").document(currentUserId).collection("wishlist").document(id).setData([
                                                    "title" : title,
                                                    "location" : location,
                                                    "image" : image,
                                                    "category" : category,
                                                    "rating" : rating,
                                                    "id" : id
                                                ]) { error in
                                                    isLoadingWishlist = false
                                                }
                                            }
                                        } label: {
                                            Image(systemName: isWishListed ? "heart.fill" : "heart")
    //                                            .font(.system(size: 25))
                                                .foregroundStyle(.white)
                                            
                                        }
                                        .padding()
                                        .frame(width: 90, height: 65)
                                        .background(Color.white.opacity(0.3))
                                        .cornerRadius(33)
                                        .shadow(color: .gray.opacity(0.5), radius: 5,x: 0,y: 0)
//                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                }
                            }
                            .padding(.leading)
                            .padding(.trailing, 5)
                            .padding(.bottom, 5)
                            .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 2)
                        .padding(.bottom, 2)
                    }
                    .offset(y: bottomOffsetValue)
                    .padding(.bottom, 40)
                    
                }//MARK: - End of ZStack
                .shadow(radius: 1.5)
                
            }
            
            
            
            
//            .cornerRadius(20)
//            .background(
//                Rectangle()
//                    .fill(Color.white)
//                    .cornerRadius(20)
//                    .shadow(color: .gray.opacity(0.6), radius: 4.5,x: 0,y: 0)
//            )
           
//            .navigationDestination(isPresented: $loginNavigationManager.showLoginView, destination: {
//                LoginView(loginNavigationManager: loginNavigationManager)
//            })
            .fullScreenCover(isPresented: $loginNavigationManager.showLoginView) {
                LoginView(loginNavigationManager: loginNavigationManager, didPresentFromSettings: true)
            }
            
//            .fullScreenCover(isPresented: $showingLoginView) {
//                LoginView()
//            }
            
            //            .padding(.bottom,-380)
        }
        
//        .sheet(item: $shareURL, content: { shareURL in
//            ActivityViewController(activityItems: [shareURL])
//        })
        
        
        
        
        .onAppear {
            
        }
    }
    
    func openGoogleMaps(latitude: Double, longitude: Double) {
         let coordinates = "\(latitude),\(longitude)"

         if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(coordinates)&directionsmode=driving") {
             if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
             } else {
                 let googleMapsWebURLString = "https://www.google.com/maps/dir/?saddr=&daddr=\(coordinates)&directionsmode=driving"
                 
                 if let urlDestination = URL(string: googleMapsWebURLString) {
                     UIApplication.shared.open(urlDestination)
                 }
             }
         }
     }
    
    
    func getGoogleMapsShareLink(latitude: Double, longitude: Double) -> URL? {
            let coordinates = "\(latitude),\(longitude)"
            return URL(string: "https://www.google.com/maps?q=\(coordinates)")
    }
    
}

//#Preview {
//    SplitCardView(title: "McDonalds", location: "775 Westminster Avenue APT D5 Brooklyn, NY, 11230", image: "z", category: "Burger", distance: 100, rating: 4.5, id: "123", latitude: 200.23, longitude: 250.14)
//        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9 * 1.3)
//        .preferredColorScheme(.dark)
//}
