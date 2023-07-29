//
//  GoogleClientRequest.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 28/07/2023.
//

import Foundation
import CoreLocation

protocol GoogleClientRequest {
    var googlePlacesKey : String { get set }
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation,withinMeters radius: Int, using completionHandler: @escaping (GooglePlacesResponse) -> ())
}

class GoogleClient: GoogleClientRequest {
    
    let session = URLSession(configuration: .default)
    var googlePlacesKey: String = "AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4"
     
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation, withinMeters radius: Int, using completionHandler: @escaping (GooglePlacesResponse) -> ())  {
         
        let url = googlePlacesDataURL(forKey: googlePlacesKey, location: location, keyword: keyword)
         let task = session.dataTask(with: url) { (responseData, _, error) in
                                                
             if let error = error {
                print(error.localizedDescription)
                  return
             }
             print("Got results \(responseData)")
             guard let data = responseData, let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                 print("empty results")
                  completionHandler(GooglePlacesResponse(results:[]))
                  return
             }
             print("Valid results \(response)")
             for item in response.results {
                 print(item.name)
                 print(item.photos?.first?.photoReference)
             }
             completionHandler(response)
        }
        task.resume()
    }
    
    func googlePlacesDataURL(forKey apiKey: String, location: CLLocation, keyword: String) -> URL {
    
         let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
         let locationString = "location=" +     String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
         let rankby = "rankby=distance"
         let keywrd = "keyword=" + keyword
         let key = "key=" + apiKey
//    let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Paris&types=geocode&key=" + key)
//        return url!
         return URL(string: baseURL + locationString + "&" + rankby + "&" + keywrd + "&" + key)!
    }
    
}


