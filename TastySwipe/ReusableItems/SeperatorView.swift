//
//  seperatorView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI

struct seperatorView: View {
    var body: some View {
        Rectangle().frame(width: .infinity, height: 1)
            .padding()
            .opacity(0.1)
    }
}

struct seperatorView_Previews: PreviewProvider {
    static var previews: some View {
        seperatorView()
    }
}
