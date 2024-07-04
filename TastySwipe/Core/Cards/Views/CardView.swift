//
//  CardView.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 11/03/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import StarRatingViewSwiftUI
//import Shimmer
struct CardView: View, Identifiable {
    
  
    
    let title : String
    let location : String
    let image : String
    let category : String
    let distance : Int
    let rating : Double
    let id : String
    let latitude : Double
    let longitude : Double
    
    
    
    @EnvironmentObject var wishListViewModel: WishListViewModel
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isLoading = false
    @State private var showingLoginView = false
    private var isWishListed: Bool {
        return wishListViewModel.wishList.contains(where: { $0.id == id })
    }
    @State private var isLoadingWishlist = false
    
 
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                
                //MARK: - Image
                ZStack {
                    AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(image)&key=AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")) { phase in
                        switch phase {
                        case .empty:
                            Color.gray
                                .clipped()
                            
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9 * 1.3)
//                                .cornerRadius(30)
//                                .frame(width: 335,height: 438)
                                .clipped()
//                                .clipShape (UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                            
                        case .failure:
                            Color.gray
                                .clipped()
                            
                        @unknown default:
                            EmptyView()
                                .frame(width: 60, height: 60)
                        }
                    }
                   
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
                    
                    
                    //MARK: - BOX bottom
                    VStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 0) {
                            Group {
                                Text(title)
                                    .lineLimit(1)
                                    .font(.system(size: 20, design: .rounded))
                                    .foregroundStyle(Color.white)
                                    .fontWeight(.bold)
                                    .padding(.top, 12)
                                
                                //MARK: - Raiting
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
                                    Spacer()
                                    
                                    //MARK: - Add to wishlist
                                    Button {
                                        print("Did tapped button")
                                        guard let currentUserId = Auth.auth().currentUser?.uid else {
                                            showingLoginView = true
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
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(33)
                                    .shadow(color: .gray.opacity(0.5), radius: 5,x: 0,y: 0)
                                    .disabled(isLoadingWishlist)
                                    
                                    
                                }
                                .padding(.top, 25)
                                .padding(.bottom)
                            }
                            .padding(.leading)
                            .padding(.trailing, 10)
                            .padding(.bottom, 5)
                            .padding(.top, 5)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 2)
                        .padding(.bottom, 2)
                    }
                    
                }//MARK: - End of ZStack
                .shadow(radius: 1.5)
                
            }
            .cornerRadius(20)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.6), radius: 4.5,x: 0,y: 0)
            )
            
            .fullScreenCover(isPresented: $showingLoginView) {
                LoginView()
            }
            
            //            .padding(.bottom,-380)
        }
    }
    
    //MARK: - Google Maps
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

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(title: "PF.Changs", location: "Jumeirah 1", image: "PF.Changs", category: "Restraunt", distance: 2, rating : 5, id: "1", latitude: 0.0, longitude: 0.0)
    }
}

