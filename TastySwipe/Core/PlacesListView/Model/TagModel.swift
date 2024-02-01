//
//  TagModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 05/01/2024.
//

import Foundation

enum TagModel : Identifiable, CaseIterable, Codable {
    case cafe,
         gym,
         beauty_salon,
         food,
         burger,
         pizza,
         sushi,
         doctor,
         gas_station,
         florist,
         tourist_attraction,
         car_wash,
         supermarket,
         dentist,
         department_store,
         electronics_store,
         bank,
         hair_care,
         hospital,
         mosque,
         museum,
         parking,
         pharmacy,
         real_estate_agency,
         shopping_mall,
         spa,
         car_rental,
         car_repair,
         stadium
          
    
    var id : Self {
        return self
    }
    
    var title : String {
        switch self {
        case .cafe:
            return "Coffee\nShops"
        case .burger:
            return "Burgers"
        case .pizza:
            return "Pizza"
        case .sushi:
            return "Sushi"
        case .food:
            return "Restaurant"
        case .gym:
            return "Gym"
        case .bank:
            return "Bank"
        case .beauty_salon:
            return "Beauty\nSalon"
        case .car_rental:
            return "Car\nRental"
        case .car_repair:
            return "Car\nRepair"
        case .car_wash:
            return "Car\nWash"
        case .dentist:
            return "Dentist"
        case .department_store:
            return "Department\nShop"
        case .doctor:
            return "Doctor"
        case .electronics_store:
            return "Electronic\nStore"
        case .florist:
            return "Flowers"
        case .gas_station:
            return "Petrol\nStation"
        case .hair_care:
            return "Barber"
        case .hospital:
            return "Hospital"
        case .mosque:
            return "Mosque"
        case .museum:
            return "Museum"
        case .parking:
            return "Parking"
        case .pharmacy:
            return "Pharmacy"
        case .real_estate_agency:
            return "Real\nEstate"
        case .shopping_mall:
            return "Shopping\nMall"
        case .spa:
            return "SPA"
        case .stadium:
            return "Stadium"
        case .supermarket:
            return "Super\nmarket"
        case .tourist_attraction:
            return "Tourist\nAttraction"
      
        }
    }
    
    var apiName : String {
        switch self {
        case .cafe:
            return "Coffee"
        case .food:
            return "Restaurants"
        case .burger:
            return "Burger"
        case .pizza:
            return "Pizza"
        case .sushi:
            return "Sushi"
        case .gym:
            return "Gym"
        case .bank:
            return "Bank OR ATM"
        case .beauty_salon:
            return "Beauty salon"
        case .car_rental:
            return "Rent a car OR Car Rental"
        case .car_repair:
            return "Car repair"
        case .car_wash:
            return "Car wash"
        case .dentist:
            return "Dentist OR Dental clinic"
        case .department_store:
            return "Department store"
        case .doctor:
            return "Doctor "
        case .electronics_store:
            return "Electronics store OR Electronics"
        case .florist:
            return "Florist OR Flowers"
        case .gas_station:
            return "Petrol Station OR Gas Station"
        case .hair_care:
            return "Haircut"
        case .hospital:
            return "Hospital OR Medical Clinic "
        case .mosque:
            return "Mosque OR Masjid"
        case .museum:
            return "Museum OR Place of interest"
        case .parking:
            return "Parking OR Paid parking"
        case .pharmacy:
            return "Pharmacy OR Drug store"
        case .real_estate_agency:
            return "Real Estate OR Rental Agency company"
        case .shopping_mall:
            return "Shopping mall OR Mall"
        case .spa:
            return "SPA OR Wellness"
        case .stadium:
            return "Rental Fields OR Stadium"
        case .supermarket:
            return "Convenience store OR Supermarkets"
        case .tourist_attraction:
            return "Tourist attraction"
        
        }
    }
    
    var emoji : String {
        switch self {
        case .bank:
            return "🏦"
        case .beauty_salon:
            return "💅🏼"
        case .cafe:
            return "☕️"
        case .car_rental:
            return "🏎️"
        case .car_repair:
            return "🛠️"
        case .car_wash:
            return "🧽"
        case .dentist:
            return "🪥"
        case .department_store:
            return "🏪"
        case .doctor:
            return "🩺"
        case .electronics_store:
            return "💻"
        case .florist:
            return "🌷"
        case .food:
            return "🍱"
        case .gas_station:
            return "⛽️"
        case .gym:
            return "🏋🏼‍♂️"
        case .hair_care:
            return "💇🏻‍♀️"
        case .hospital:
            return "🏥"
        case .mosque:
            return "🕌"
        case .museum:
            return "🖼️"
        case .parking:
            return "🅿️"
        case .pharmacy:
            return "💊"
        case .real_estate_agency:
            return "🏢"
        case .shopping_mall:
            return "🛍️"
        case .spa:
            return "🧖🏼‍♂️"
        case .stadium:
            return "🏀"
        case .supermarket:
            return "🛒"
        case .tourist_attraction:
            return "🎡"
        case .burger:
            return "🍔"
        case .pizza:
            return "🍕"
        case .sushi:
            return "🍣"
        }
    }
    
}
