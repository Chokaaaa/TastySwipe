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
                                  .cornerRadius(20)
                                  .frame(width: 180,height: 230)
                                  .clipped()
                                  .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20))
                          case .success(let image):
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .cornerRadius(20)
                                  .frame(width: 180,height: 230)
                                  .clipped()
                                  .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20))
                          case .failure:
                              Image("PF.Changs")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .cornerRadius(20)
                                  .frame(width: 180,height: 230)
                                  .clipped()
                                  .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 20))
                          @unknown default:
                              EmptyView()
                                  .frame(width: 60, height: 60)
                          }
                      }
                      VStack(alignment: .leading) {
                          
                          HStack {
                              Text(title)
                                  .foregroundStyle(Color("SystemTextColor"))
                                  .font(.system(size: 15))
                                  .bold()
                              .padding(.leading, -8)
                              Spacer()
                              
                              
                              
                            
//                              Button {
//                                  print("")
//                              } label: {
//                                  Image(systemName: "square.and.arrow.up")
//                                      .font(.footnote)
//                                      .padding(.trailing, -5)
//                              }

                              
                          }
                          
                      }
                      
                      .padding()
                      .frame(width: 180, alignment: .leading)
                      .background(Color("SystemBgColor"))
                      .clipShape(UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 0))
                      
                      
                  }
                  
                  .frame(width: 180, height: 235)
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
                          .foregroundStyle(Color.accentColor)
                          .background(.white)
                          .clipShape(Circle())
                          .padding()
                          .frame(width: 40, height: 40)
                  }
              }
              .background(
                  RoundedRectangle(cornerRadius: 20)
                      .frame(width: 180, height: 230)
              )
              .padding()
    }
}

#Preview {
    FavoriteCardView(image: "PF.Changs", title: "Pf Changs", id: "0")
        .environmentObject(ColorSchemeManager())
}
