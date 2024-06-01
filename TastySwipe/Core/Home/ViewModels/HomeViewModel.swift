//
//  HomeViewModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 28/07/2023.
//

import Foundation
import CoreLocation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

enum FetchLocationError: Error {
    case permissionDenied
}

class HomeViewModel : NSObject, ObservableObject {
    
    
    lazy var googleClient: GoogleClientRequest = GoogleClient()
    @Published var locationName : String = "Coffee"
    var searchRadius : Int = 1000
    private let locationManager = CLLocationManager()
    @Published var cardViews : [CardView] = []
    @Published var activeCard : CardView?
    @Published var isFetching = false
    @Published var showNoLocationView = false
    var didFetchLocations = false
    var currentLocation : CLLocation?
    var token : String?
    typealias FetchLocation = (Result<(latitude: Double, longitude: Double), FetchLocationError>) -> Void
    var fetchLocationCompletion: FetchLocation?
    @AppStorage("filterByRating") var filterByRating = 3
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: - Changing the category api call
    func fetchPlaces(locationName: String, filterByRating : Int) {
        guard let location = currentLocation else { return }
        print("Calling fetch places 1")
        self.locationName = locationName
        print("Location name \(locationName)")
        cardViews.removeAll()
        self.filterByRating = filterByRating
        isFetching = true
        googleClient.getGooglePlacesData(forKeyword: locationName, location: location, withinMeters: searchRadius, token: nil) { response in
//            self.currentLocation = location
            self.token = response.next_page_token
            guard response.results.count > 0 else {
                self.isFetching = false
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fetchNextPlaces(location: location, results: response.results)
            }
        }
    }
    
    //MARK: - First Time Load
    func fetchPlaces(location: CLLocation) {
        isFetching = true
            self.googleClient.getGooglePlacesData(forKeyword: self.locationName, location: location, withinMeters: self.searchRadius, token: nil) { response in
                
                print("Calling fetch places 2")
                self.currentLocation = location
                self.token = response.next_page_token
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchNextPlaces(location: location, results: response.results)
                }
            }
    }
    
    
    func fetchNextPlaces(location: CLLocation, results : [Place]) {
        guard let token = token else {
            sortAndDisplayResults(results: results, location: location)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.googleClient.getGooglePlacesData(forKeyword: self.locationName, location: location, withinMeters: self.searchRadius, token: self.token) { response in
                print("Calling fetch places 2")
//                self.currentLocation = location
                self.token = response.next_page_token
                let totalResults = results + response.results
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.fetchNextPlaces(location: location, results: totalResults)
                }
            }
        }
        
    }
    
    
    
    func sortAndDisplayResults(results: [Place], location: CLLocation) {
        isFetching = false
        let orderedResults = results.sorted { place1, place2 in
            let endLocation1 = CLLocation(latitude: place1.geometry.location.latitude, longitude: place1.geometry.location.longitude)
            let distance1 = self.getDistance(startLocation: location, endLocation: endLocation1)
            
            let endLocation2 = CLLocation(latitude: place2.geometry.location.latitude, longitude: place2.geometry.location.longitude)
            let distance2 = self.getDistance(startLocation: location, endLocation: endLocation2)
            
            return distance1 < distance2
            
        }
        
        self.cardViews.removeAll()
        for item in orderedResults {
            
            //                if item.rating < 4  {
            //                    continue
            //                }
           
            guard item.rating >= Double(filterByRating) else {
                continue
            }
            
            if let photos = item.photos,
               let firstPhoto = photos.first {
                let endLocation = CLLocation(latitude: item.geometry.location.latitude, longitude: item.geometry.location.longitude)
                let distance = self.getDistance(startLocation: location, endLocation: endLocation)
                self.cardViews.append(CardView(title: item.name, location: item.address, image: firstPhoto.photoReference, category: "Food",/*"\(item.types)".capitalized,*/ distance: distance, rating: item.rating, id: item.place_id, latitude: item.geometry.location.latitude, longitude: item.geometry.location.longitude))
                
                
                print("current distance 2 is \(distance)")
                print("Category from response \(item.types)")
                print("Name from response \(item.name)")
            }
        }
        
        self.activeCard = cardViews.first
        
    }
    
 
    
    func getDistance(startLocation : CLLocation, endLocation : CLLocation) -> Int {
        let distance: CLLocationDistance = startLocation.distance(from: endLocation)
        print("Start location \(startLocation)")
        return Int(distance.magnitude)
    }
    
    func fetchLocation(fetchLocationCompletion: @escaping FetchLocation) {
        self.fetchLocationCompletion = fetchLocationCompletion
        locationManager.requestLocation()
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            fetchLocationCompletion(.failure(.permissionDenied))
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
            
        @unknown default:
            print("error getting location")
        }
        
        
    }
    
}

extension HomeViewModel : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !didFetchLocations else { return }
        guard let location = locations.first else { return }
        print("# updateLocations")
        didFetchLocations = true
        fetchLocationCompletion?(.success((location.coordinate.latitude, location.coordinate.longitude)))
        fetchPlaces(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            showNoLocationView = true
        }
    }
    
}

