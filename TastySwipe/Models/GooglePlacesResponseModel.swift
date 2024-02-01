//
//  GooglePlacesResponseModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 28/07/2023.
//

import Foundation

struct GooglePlacesResponse : Codable {
    let results : [Place]
    var next_page_token : String?
    
    enum CodingKeys : String, CodingKey {
        case next_page_token = "next_page_token"
        case results = "results"
    }
    
}

struct Place : Codable {
    let place_id : String
    let geometry : Location
    let name : String
    let openingHours : OpenNow?
    var photos : [PhotoInfo]?
    let types : [String]
    let address : String
    let rating : Double
    
    enum CodingKeys : String, CodingKey {
        case place_id = "place_id"
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case types = "types"
        case address = "vicinity"
        case rating = "rating"
    }
    
    struct Location : Codable {
        
        let location : LatLong
        
        enum CodingKeys : String, CodingKey {
            case location = "location"
        }
        
        struct LatLong : Codable {
            
            let latitude : Double
            let longitude : Double
            
            enum CodingKeys : String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
    
    struct OpenNow : Codable {
        
        let isOpen : Bool
        
        enum CodingKeys : String, CodingKey {
            case isOpen = "open_now"
        }
    }
    
    struct PhotoInfo : Codable {
        
        let height : Int
        let width : Int
        let photoReference : String
        
        enum CodingKeys : String, CodingKey {
            case height = "height"
            case width = "width"
            case photoReference = "photo_reference"
        }
    }
}


extension Place : Hashable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.place_id == rhs.place_id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(place_id)
    }
    
}
