//
//  PurchasesManager.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 06/01/2024.
//

import Foundation

//MARK: - Revenue cat Manager

import Foundation
import RevenueCat
import SwiftUI


class PurchasesManager: ObservableObject {
    
    @Published var packages: [Package] = [Package]()
    @Published var isSubscriptionActive = false
    var products : [PremiumPackage] {
        return packages.map { PremiumPackage(package: $0) }
    }
    
    init() {
        Purchases.configure(withAPIKey: "appl_CvgGNQYNduWDdNSUdgCZBXyajCN", appUserID: nil)
        getPackages()
        if Config.shared.isDevMode {
            isSubscriptionActive = true
        } else {
            print("Got to this block")
            updatePlusSubscriptionStatus()
        }
    }
    
    func getPackages() {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                print("Get Offerings Error: \(error.localizedDescription)")
                return
            }
            self.packages.removeAll()
            if let packages = offerings?.current?.availablePackages {
                self.packages += packages
            }
            for package in self.packages {
                print("received a package \(package.offeringIdentifier)")
            }
        }
    }
    
    func purchasePremiumSubscription(identifier: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let premiumPackages = packages.filter { package in
            if package.offeringIdentifier == "default" {
                return true
            }
            return false
        }
        guard premiumPackages.count > 0 else {
            print("no premium package")
            completion(false, nil)
            return
        }
        let purchasedPackage = premiumPackages.first { package in
            if package.identifier == identifier {
                return true
            }
            return false
        }
        guard let purchasedPackage = purchasedPackage else {
            completion(false, nil)
            return
        }
        Purchases.shared.purchase(package: purchasedPackage) { (transaction, customerInfo, error, userCancelled) in
            if let error = error {
                print("Purchase Error: \(error.localizedDescription)")
                completion(false, "There was an error completing your purchase. Please try again later.")
                return
            }
            if userCancelled {
                completion(false, nil)
            }
            if let customerInfo = customerInfo,
             let entitlement = customerInfo.entitlements["premium"],
             entitlement.isActive == true {
                print("premium sub is now active")
                self.isSubscriptionActive = true
                completion(true, nil)
            } else {
              print("premium sub is not active")
                self.isSubscriptionActive = false
                completion(false, nil)
          }
        }
    }
    
    func restorePurchases(completion: @escaping (_ success: Bool) -> Void) {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            if let customerInfo = customerInfo,
             let entitlement = customerInfo.entitlements["premium"],
             entitlement.isActive == true {
                completion(true)
            } else {
                completion(false)
          }
        }
    }
    
    func updatePlusSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Get Customers Error: \(error.localizedDescription)")
                self.isSubscriptionActive = false
                return
            }
            if let _ = customerInfo?.entitlements["premium"]?.isActive {
                print("Customer is active")
                print("purchase date \(customerInfo?.originalPurchaseDate)")
                print("isSandbod \(customerInfo?.entitlements["premium"]?.isSandbox)")
                self.isSubscriptionActive = true
            } else {
                print("Customer is not active")
                self.isSubscriptionActive = false
            }
            
        }
    }
    
}
