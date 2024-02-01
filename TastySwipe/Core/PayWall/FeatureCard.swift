//
//  FeatureCard.swift
//  MyTradingJournal
//
//  Created by James Sedlacek on 11/22/22.
//

import SwiftUI

enum FeatureCard {
    case unlimitedEntries
    case importData
    case biometricsLock
    case automaticBackups
    case customTags
    case moreStats
    case moreDates
    case unlimitedGoals
    case food9
    case food10
    case food11
    case food12
    case food13
    case food14
    case food15
    case food16
    case food17
    case food18
    case food19
    case food20
    
    
    var title: String {
        switch self {
        case .unlimitedEntries:
            return "Unlimited Entries"
        case .importData:
            return "Import Data"
        case .biometricsLock:
            return "Biometrics Lock"
        case .automaticBackups:
            return "Automatic Backups"
        case .customTags:
            return "Custom Tags"
        case .moreStats:
            return "More Stats"
        case .moreDates:
            return "More Dates"
        case .unlimitedGoals:
            return "Unlimited Goals"
        case .food9:
            return "Unlimited Goals"
        case .food10:
            return "Unlimited Goals"
        case .food11:
            return "Unlimited Goals"
        case .food12:
            return "Unlimited Goals"
        case .food13:
            return "Unlimited Goals"
        case .food14:
            return "Unlimited Goals"
        case .food15:
            return "Unlimited Goals"
        case .food16:
            return "Unlimited Goals"
        case .food17:
            return "Unlimited Goals"
        case .food18:
            return "Unlimited Goals"
        case .food19:
            return "Unlimited Goals"
        case .food20:
            return "Unlimited Goals"
        }
    }
    
    var iconImage: Image {
        switch self {
        case .unlimitedEntries:
            return .entriesIcon
        case .importData:
            return .importIcon
        case .biometricsLock:
            return .biometricsIcon
        case .automaticBackups:
            return .cloudIcon
        case .customTags:
            return .tagsIcon
        case .moreStats:
            return .statsIcon
        case .moreDates:
            return .calendarIcon
        case .unlimitedGoals:
            return .goalsIcon
        case .food9:
            return .food9
        case .food10:
            return .food10
        case .food11:
            return .food11
        case .food12:
            return .food12
        case .food13:
            return .food13
        case .food14:
            return .food14
        case .food15:
            return .food15
        case .food16:
            return .food16
        case .food17:
            return .food17
        case .food18:
            return .food18
        case .food19:
            return .food19
        case .food20:
            return .food20
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .unlimitedEntries:
            return .darkOrange
        case .importData:
            return .blue
        case .biometricsLock:
            return .green
        case .automaticBackups:
            return .darkRed
        case .customTags:
            return .blue
        case .moreStats:
            return .green
        case .moreDates:
            return .blue
        case .unlimitedGoals:
            return .green
        case .food9:
            return .blue
        case .food10:
            return .blue
        case .food11:
            return .blue
        case .food12:
            return .blue
        case .food13:
            return .blue
        case .food14:
            return .blue
        case .food15:
            return .blue
        case .food16:
            return .blue
        case .food17:
            return .blue
        case .food18:
            return .blue
        case .food19:
            return .blue
        case .food20:
            return .blue
        }
    }
}
