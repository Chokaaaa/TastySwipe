//
//  ArrayExtension.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 18/01/2024.
//

import Foundation
import SwiftUI

extension Array where Element: Hashable {
  func unique() -> [Element] {
    Array(Set(self))
  }
}
