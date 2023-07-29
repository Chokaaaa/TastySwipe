//
//  HomeViewModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 28/07/2023.
//

import Foundation
import CoreLocation

class HomeViewModel : NSObject, ObservableObject {
    
     
    lazy var googleClient: GoogleClientRequest = GoogleClient()
    var locationName : String = "Food"
    var searchRadius : Int = 3000
    private let locationManager = CLLocationManager()
    @Published var cardViews : [CardView] = []
    
    override init() {
        super.init()
        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchPlaces(location: CLLocation) {
        googleClient.getGooglePlacesData(forKeyword: locationName, location: location, withinMeters: searchRadius) { response in
            for item in response.results {
                if let photos = item.photos,
                   let firstPhoto = photos.first {
                    self.cardViews.append(CardView(title: item.name, location: item.address, image: firstPhoto.photoReference, category: "Restraunts"))
                }
            }
        }
    }
    
}

extension HomeViewModel : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        print("Did get location\(location.coordinate.latitude)")
        fetchPlaces(location: location)
        locationManager.stopUpdatingLocation()
    }
}

