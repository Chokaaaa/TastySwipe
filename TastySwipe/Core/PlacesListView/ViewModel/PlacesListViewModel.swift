//
//  PlacesListViewModel.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 05/01/2024.
//

import Foundation

class PlacesListViewModel : ObservableObject {
    
    @Published var selectedTags : [TagModel] = []
    
    func tagSelected(tag: TagModel) {
        
        if selectedTags.contains(tag) {
            selectedTags.removeAll(where: { $0 == tag })
        } else {
//            guard selectedTags.count < 1 else { return }
            selectedTags.removeAll()
            selectedTags.append(tag)
        }
    }
    
}
