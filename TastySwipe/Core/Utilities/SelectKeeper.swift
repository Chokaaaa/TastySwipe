//
//  SelectKeeper.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 15/02/2024.
//

import Foundation

struct SelectKeeper<T: Hashable> {

var selections = Set<T>()

    mutating func select(_ value: T) {
        selections.insert(value)
    }
    
    mutating func deselectAll() {
        selections.removeAll()
    }

    mutating func deselect(_ value: T) {
        selections.remove(value)
    }

    mutating func toggleSelection(_ value: T) {
        if selections.contains(value) {
            selections.remove(value)
        } else {
            selections.insert(value)
        }
    }
    
    func isSelected(_ value: T) -> Bool {
    return selections.contains(value)
    }

    typealias SelectionValue = T
}
