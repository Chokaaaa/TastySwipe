//
//  TabManager.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/06/2024.
//

import Foundation
import SwiftUI


class TabManager: ObservableObject {
    @Published var showHiddenTab = false
    @Published var selectedTab = 0
}
