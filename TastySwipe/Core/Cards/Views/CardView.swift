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
import Shimmer
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
    
    @State private var showingLoginView = false
    @StateObject var viewModel = WishListViewModel()
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isLoading = false
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
                
                //MARK: - Image
                ZStack(alignment: .top) {
                    AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(image)&key=AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")) { phase in
                        switch phase {
                        case .empty:
                            Image("loading")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(20)
                                .frame(width: 350,height: 280)
                                .clipped()
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                            
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(20)
                                .frame(width: 350,height: 280)
                                .clipped()
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                            
                        case .failure:
                            Image("loading")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(20)
                                .frame(width: 350,height: 280)
                                .clipped()
                                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                            
                        @unknown default:
                            EmptyView()
                                .frame(width: 60, height: 60)
                        }
                    }
                    //MARK: - Distance marker in glass bg
                    HStack(spacing: 0) {
                        Image(systemName: "location.fill")
                            .scaledToFit()
                            .padding(.leading,5)
                        Text("\(distance) m")
                            .font(.system(size: 15, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color("SystemTextColor"))
//                            .padding(.trailing,0)
                            .frame(width: 65, height: 45)
                    }
                    .background(
                        .thinMaterial,
                        in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                    )
                    .frame(width: 90, height: 35.35)
                    .padding(.top,50)
                    .padding(.trailing,250)
                }//MARK: - End of ZStack
                .frame(maxWidth: 350, maxHeight: 200)
                .shadow(radius: 1.5)
                //MARK: - Text(title,category,location)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(title)
                            .lineLimit(1)
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.bold)
                            .padding(.horizontal, 15)
                            
                        
                        Spacer()
                        
                        //MARK: - Raiting
                        StarRatingView(rating: Float(rating), color: Color.yellow, maxRating: 5)
                            .frame(width: 25, height: 15, alignment: .leading)
                            .padding(.trailing, 60)
                        Text(String(format: "%.1f", rating))
                            .foregroundStyle(.yellow)
                            .padding(.trailing, 5)
                            
                    }
                    .padding(.top,55)
                    
                    
                    Text(category)
                        .font(.system(size: 14, design: .rounded))
                        .fontWeight(.regular)
                        .padding(.horizontal, 15)
                    
                    Text(location)
                        .lineLimit(1)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.gray)
                        .fontWeight(.regular)
                        .padding(.horizontal, 15)
                    
                    
                    //MARK: - Action Buttons
                    HStack(spacing: 12) {
                        
                        //MARK: - Dislike
                        Button {
                            print("dislike")
                            
                            
                            
                        } label: {
                            Image(systemName: "hand.thumbsdown")
                                .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                        }
                        
                        
                        //MARK: - Create route
                        Button {
                            openGoogleMaps(latitude: latitude, longitude: longitude)
                        } label: {
                            Image(systemName: "location")
                                .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                        }
                        
                            //MARK: - Add to wishlist
                            Button {
                                if let currentUserId = Auth.auth().currentUser?.uid {
                                    Firestore.firestore().collection("users").document(currentUserId).collection("wishlist").document(id).setData([
                                        "title" : title,
                                        "location" : location,
                                        "image" : image,
                                        "category" : category,
                                        "rating" : rating,
                                        "id" : id
                                    ])
                                } else {
                                    showingLoginView.toggle()
                                }
                            } label: {
                                Image(systemName: "star")
                                    .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                            }
    //                    }
                        //MARK: - Web
                        Button {
                            
                            if let url = getGoogleMapsShareLink(latitude: latitude, longitude: longitude) {
                                            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                                            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
                            }
                            
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                        }
                        
                        
                        //MARK: - Like
                        Button {
                            print("like")
                        } label: {
                            Image(systemName: "hand.thumbsup")
                                .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                        }
                    }
                    .padding()

                    
                }
                
                .frame(maxWidth: 350, maxHeight: 200)
                
                
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
