//
//  NoLocationSharedView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 16/02/2024.
//

import SwiftUI
import CoreLocation

struct NoLocationSharedView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    private let locationManager = CLLocationManager()
    
    var body: some View {
        VStack{
                
                // MARK: Movable Slides
                VStack{
                    
                        Image("settingsGear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 285, height: 285, alignment: .center)
                    
                    
                    VStack(spacing: 25) {
                        
                        Text("We need your location")
                            .font(.title.bold())
                        
                        
                        
                        Text("Sorry, we need your location to better enhance your experience")
                            .font(.system(size: 14))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,15)
                            .foregroundColor(.gray)
                        
                    
       
                    Button {
                        
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(settingsURL)

                        
                    } label: {
                        Text("Allow Location")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical,20)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(Color.accentColor)
                            }
                            .padding(.horizontal,20)
                    }
                    }
                }
                .padding(.top, 15)
            }
        
        .onChange(of: scenePhase, { oldValue, newValue in
            if newValue == .active {
                switch locationManager.authorizationStatus {
                    
                case .authorizedAlways, .authorizedWhenInUse:
                dismiss()
                    
                default:
                    print("error getting location")
                }
            }
        })
        
    }
}

#Preview {
    NoLocationSharedView()
}
