//
//  PremiumPackage.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 13/01/2024.
//

import Foundation
import SwiftUI
import RevenueCat

struct PremiumPackage : Identifiable {
    
    let id : String
    let name : String
    
    let price : String
    
    init(package : Package) {
        id = package.identifier
        print("Premium Package Id \(package.identifier)")
        if package.identifier == "$rc_monthly" {
            //MARK: - Name of the monthly package
            name = "Monthly"
        } else if package.identifier == "$rc_annual" {
            //MARK: - Name of the yearly package
            name = "Yearly"
        } else {
            name = ""
        }
        price = package.localizedPriceString
    }
    
}

extension PremiumPackage : Equatable {
    
    static func == (lhs: PremiumPackage, rhs: PremiumPackage) -> Bool {
        
        return lhs.id == rhs.id
        
    }
    
}
