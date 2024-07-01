//
//  TestView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 03/06/2024.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack {
            Image("burjAlArab")
                .resizable()
                .aspectRatio(contentMode: .fill)
            VisualEffectBlur(blurStyle: .systemThinMaterialDark)
                .ignoresSafeArea()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    TestView()
}
