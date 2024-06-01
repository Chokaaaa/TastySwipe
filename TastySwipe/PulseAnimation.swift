//
//  PulseAnimation.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 05/02/2024.
//

import Foundation

import SwiftUI

struct PulseAnimation: View {
    
    var imageName: String
    var imageSize: CGFloat {
        UIScreen.main.bounds.width / 7.5
    }
    var animationDuration: CGFloat
    @State private var startAnimation = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    .opacity(startAnimation ? 0 : 0.3),
                    style: StrokeStyle(lineWidth: startAnimation ? 0.0 : 1)
                )
                .frame(width: imageSize, height: imageSize)
                .scaleEffect(startAnimation ? 4 : 1)
                .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: false), value: startAnimation)
            Circle()
                .stroke(
                    .opacity(startAnimation ? 0 : 0.3),
                    style: StrokeStyle(lineWidth: startAnimation ? 0.0 : 1)
                )
            
                .frame(width: imageSize, height: imageSize)
                .scaleEffect(startAnimation ? 3 : 1)
                .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: false).delay(1), value: startAnimation)
            Circle()
                .stroke(
                    .opacity(startAnimation ? 0 : 0.3),
                    style: StrokeStyle(lineWidth: startAnimation ? 0.0 : 1)
                )
                .frame(width: imageSize, height: imageSize)
                .scaleEffect(startAnimation ? 2 : 1)
                .animation(Animation.easeInOut(duration: animationDuration).repeatForever(autoreverses: false).delay(2), value: startAnimation)
            
            
            VStack(spacing: 0) {
                Image(systemName: imageName )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(6)
                    .background(Color.accentColor)
                    .cornerRadius(36)
            }
            
            
//                .resizable()
//                .frame(width: imageSize, height: imageSize)
//            // MARK: - The next two lines should be removed if your image background is not transparent.
//                .background(Color(.systemIndigo))
//                .cornerRadius(100)
            // MARK: -
                .scaleEffect(startAnimation ? 1.25 : 1)
            .animation(Animation.easeInOut(duration: animationDuration / 2).repeatForever(autoreverses: true).delay(0.5), value: startAnimation)
                .shadow(radius: 35)
                .onAppear {
                    withAnimation {
                        self.startAnimation = true
                    }
                }
        }
        .scaleEffect(startAnimation ? 1 : 0)
        .animation(.spring().speed(0.5), value: startAnimation)
    }
}

struct PulseAnimation_Previews: PreviewProvider {
    static var previews: some View {
        PulseAnimation(imageName: "heart.circle", animationDuration: 4)
    }
}
