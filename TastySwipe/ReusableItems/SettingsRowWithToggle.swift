////
////  SettingsRowWithToggle.swift
////  TastySwipe
////
////  Created by Nursultan Yelemessov on 31/12/2023.
////
//
//import SwiftUI
//
//struct SettingsRowWithToggle: View {
//    
//    @AppStorage("user_face_id") var userFaceID : Bool = false
//    
//    let title: String
//    let imageName: String
//    let bgColor : Color
//    
//    var body: some View {
//        
//        HStack(spacing: 25) {
//            ZStack {
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(bgColor)
//                        
//                        HStack(spacing: 15) {
//                            Image(systemName: imageName)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                                .foregroundColor(Color.white)
//                            
//                          
//                        }
//                        .padding(5)
//                    }
//            .frame(width: 15, height: 10)
//            
//            Text(title)
//                .font(.body)
//            
//            
//            if userFaceID {
//                
//                Button(action: {
//                    
//                }, label: {
//                    
//                })
//                
//            } else {
//                Toggle("", isOn: $userFaceID)
//            }
//
//            
//        }
//        
//    }
//}
//
//#Preview {
//    SettingsView()
//        .environmentObject(ColorSchemeManager())
//}
//
//
//
//
