//
//  FeatureCardView.swift
//  MyTradingJournal
//
//  Created by James Sedlacek on 11/22/22.
//

import SwiftUI

struct FeatureCardView: View {
    let featureCard: FeatureCard
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            featureCard.iconImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 150)
                .background(featureCard.backgroundColor)
                .cornerRadius(12)
        }
    }
}

struct FeatureCardView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: -20) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    FeatureCardView(featureCard: .unlimitedEntries)
                    FeatureCardView(featureCard: .importData)
                    FeatureCardView(featureCard: .biometricsLock)
                    FeatureCardView(featureCard: .automaticBackups)
                }
            }.padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    FeatureCardView(featureCard: .importData)
                    FeatureCardView(featureCard: .unlimitedEntries)
                    FeatureCardView(featureCard: .biometricsLock)
                    FeatureCardView(featureCard: .automaticBackups)
                }
            }.padding()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    FeatureCardView(featureCard: .unlimitedEntries)
                    FeatureCardView(featureCard: .importData)
                    FeatureCardView(featureCard: .unlimitedEntries)
//                    FeatureCardView(featureCard: .biometricsLock)
                    FeatureCardView(featureCard: .automaticBackups)
                }
            }.padding()
//
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 16) {
//                    FeatureCardView(featureCard: .customTags)
//                    FeatureCardView(featureCard: .moreStats)
//                    FeatureCardView(featureCard: .moreDates)
//                    FeatureCardView(featureCard: .unlimitedGoals)
//                }
//            }
//            .padding(.horizontal, -90)
        }
    }
}
