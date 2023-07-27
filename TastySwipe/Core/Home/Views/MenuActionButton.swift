//
//  MenuActionButton.swift
//  ExploreMate
//
//  Created by Nursultan Yelemessov on 09/03/2023.
//

import SwiftUI

struct MenuActionButton: View {
    
    @Binding var mapState : MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewModel
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    func actionForState(_ state : MapViewState) {
        switch state {
        case .noInput:
            print("DEBUG: No input")
            mapState = .showMenu
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .showMenu, .polylineAdded:
            mapState = .noInput
            viewModel.selectedExploreLocation = nil
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String {
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .polylineAdded:
            return "arrow.left"
        case .showMenu:
            return "xmark"
        default:
            return "line.3.horizontal"
        }
    }
    
}

struct MenuActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuActionButton(mapState: .constant(.noInput))
    }
}
