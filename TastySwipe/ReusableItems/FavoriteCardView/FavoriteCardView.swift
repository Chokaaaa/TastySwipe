//
//  FavoriteCardView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/01/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import StarRatingViewSwiftUI

struct FavoriteCardView: View {
    
    let image : String
    let title : String
//    let category : String
//    let rating : Double
    let id : String
    
    @State private var isShowingPayWall = false
    
//    @Environment(\.colorScheme) var current
    @EnvironmentObject var csManager: ColorSchemeManager
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
                  ZStack(alignment: .bottom) {
                      
                      //MARK: - Image
                      AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(image)&key=AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")) { phase in
                          switch phase {
                          case .empty:
                              Image("PF.Changs")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  
                                  .frame(width: 180,height: 230)
                                  .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20))
                                  .clipped()
                          case .success(let image):
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  
                                  .frame(width: 180,height: 230)
                                  .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20))
                                  .clipped()
                          case .failure:
                              Image("PF.Changs")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  
                                  .frame(width: 180,height: 230)
                                  .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20))
                                  .clipped()
                          @unknown default:
                              EmptyView()
                                  .frame(width: 180, height: 230)
                          }
                      }
                      VStack(alignment: .leading) {
                          
                          HStack {
                              Text(title)
                                  .foregroundStyle(Color("SystemTextColor"))
                                  .font(.system(size: 15))
                                  .bold()
                                  .padding(.horizontal)
                                  .padding(.vertical, 10)
                              Spacer()
                          }
//                          .background(Color("SystemBgColor"))
                          .background(.regularMaterial)
                          .clipShape(RoundedRectangle(cornerRadius: 15))
                          .padding(.horizontal, 2)
                          .padding(.bottom, 2)
                      }
                      
//                      .padding()
//                      .frame(width: 180, alignment: .leading)
//                      .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 0))
                      
                      
                  }
                  
//                  .frame(width: 180, height: 235)
                  .shadow(radius: 1.5)
                  
                  Button {
                      if let currentUserId = Auth.auth().currentUser?.uid {
                             let docRef = Firestore.firestore().collection("users").document(currentUserId).collection("wishlist").document(id)
                             
                             // Delete the document
                             docRef.delete { error in
                                 if let error = error {
                                     print("Error deleting document: \(error)")
                                 } else {
                                     print("Document successfully deleted!")
                                 }
                             }
                         } else {
                             print("Not deleted")
                         }
                  } label: {
                      Image(systemName : "xmark")
                          .padding(5)
                          .foregroundStyle(Color.black)
                          .background(.white)
                          .clipShape(Circle())
                          .padding()
                          .frame(width: 40, height: 40)
                  }
              }
              .background(
                  RoundedRectangle(cornerRadius: 20)
//                      .frame(width: 180, height: 230)
              )
              .padding()
    }
}

#Preview {
    FavoriteCardView(image: "PF.Changs", title: "Pf Changs", id: "0")
        .environmentObject(ColorSchemeManager())
}
