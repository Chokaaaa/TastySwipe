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
                    let endLocation = CLLocation(latitude: item.geometry.location.latitude, longitude: item.geometry.location.longitude)
                    let distance = self.getDistance(startLocation: location, endLocation: endLocation)
                    self.cardViews.append(CardView(title: item.name, location: item.address, image: firstPhoto.photoReference, category: "Restraunts", distance: distance))
                }
            }
        }
    }
    
    func getDistance(startLocation : CLLocation, endLocation : CLLocation) -> Int {
         let distance: CLLocationDistance = startLocation.distance(from: endLocation)
        return Int(distance.magnitude)
    }
    
}

extension HomeViewModel : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        fetchPlaces(location: location)
        locationManager.stopUpdatingLocation()
    }
}

