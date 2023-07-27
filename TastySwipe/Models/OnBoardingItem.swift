//
//  OnBoardingItem.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 21/04/2023.
//

import Foundation
import Lottie


struct OnBoardingItem: Identifiable, Equatable {
    var id: UUID = .init()
    var title : String
    var focusWord : String
    var subTitle : String
    var lottieView : LottieAnimationView = .init()
}
