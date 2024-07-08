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
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation,withinMeters radius: Int, token : String?, using completionHandler: @escaping (GooglePlacesResponse) -> ())
}

class GoogleClient: GoogleClientRequest {
    
    let session = URLSession(configuration: .default)
    var googlePlacesKey: String = "AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4"
     
    func getGooglePlacesData(forKeyword keyword: String, location: CLLocation, withinMeters radius: Int, token : String? = nil,  using completionHandler: @escaping (GooglePlacesResponse) -> ())  {
         print("Did get first results")
        let url = googlePlacesDataURL(forKey: googlePlacesKey, location: location, keyword: keyword, radius: radius, token: token)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let task = self.session.dataTask(with: url) { (responseData, _, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let data = responseData,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] {
                    print("Results \(json)")
                }
                guard let data = responseData, let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                    print("empty results")
                    completionHandler(GooglePlacesResponse(results:[], next_page_token: nil))
                    return
                }
                completionHandler(response)
//                if response.next_page_token == nil {
//                    completionHandler(response)
//                    return
//                } else {
//                    print("Getting next Results")
//                    print("current Page results \(response.results.count)")
//                    self.getNextResults(keyword: keyword, location: location, token: response.next_page_token, step: 1, results: response.results, completionHandler: completionHandler)
//                }
                
                
            }
            task.resume()
        })
    }
    
    func getNextResults(keyword: String, location: CLLocation, token: String? = nil, step: Int, radius: Int, results : [Place], completionHandler: @escaping (GooglePlacesResponse) -> () ) {
        let url = googlePlacesDataURL(forKey: googlePlacesKey, location: location, keyword: keyword, radius: radius , token: token)
        print("Token is \(token)")
        print("the URL is \(url.absoluteString)")
        print("did get next results")
            let task = URLSession(configuration: .default).dataTask(with: url) { (responseData, _, error) in

                if let error = error {
                    if let httpResponse = responseData as? HTTPURLResponse, httpResponse.statusCode == 403 {
                        if let data = responseData, let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let errorMessage = errorJson["error_message"] as? String, errorMessage == "OVER_QUERY_LIMIT" {
                                print("OVER_QUERY_LIMIT error. Check your usage limits.")
                                // You may want to implement some logic to handle this situation during testing.
                            }
                        }
                    }
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = responseData,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String : Any] {
                    print("Next Page Results \(step) \(json)")
                }
                
                guard let data = responseData, let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                    print("empty results")
                    completionHandler(GooglePlacesResponse(results: results, next_page_token: token))
                    return
                }
                print("Next Page results \(response.results.count)")
                if step == 2 || response.next_page_token == nil {
                    print("Stop getting next results \(step) \(response.next_page_token)")
                    completionHandler(GooglePlacesResponse(results: results + response.results, next_page_token: token))
                    return
                } else {
                    print("Getting next results 2")
                    let totalResults = results + response.results
                    self.getNextResults(keyword: keyword, location: location, token: response.next_page_token, step: step + 1, radius: radius, results: totalResults, completionHandler: completionHandler)
                    
                }
                
//                completionHandler(response)
            }
            task.resume()
    }
    
    func googlePlacesDataURL(forKey apiKey: String, location: CLLocation, keyword: String, radius: Int, token : String? = nil) -> URL {
    
         let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
         let locationString = "location=" + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
         let rankby = "rankby=distance"
         let keywrd = "keyword=" + keyword
         let key = "key=" + apiKey
         let radius = "radius=" + "\(radius)"
//    let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Paris&types=geocode&key=" + key)
//        return url!
        if let token = token {
            return URL(string: baseURL + locationString + "&" + radius + "&" + keywrd + "&" + key + "&pagetoken=\(token)"  )!
        }
         return URL(string: baseURL + locationString + "&" + radius + "&" + keywrd + "&" + key)!
    }
    
}


