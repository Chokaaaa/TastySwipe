//
//  PlanView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 13/01/2024.
//

import SwiftUI

struct PlanView: View {
    
//    @Binding var selectedPlan: PremiumPlan
//    let plan: PremiumPlan = .monthly
    
    let product: PremiumPackage
    @Binding var selectedProductId: String
    
    var body: some View {
        
            HStack(spacing: 16) {
                if selectedProductId == product.id {
                    Image.checkmarkCircleIcon
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                } else {
                    Image.circleIcon
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.accentColor)
                }
                
                Text("\(product.name) - \(product.price)")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .padding(.horizontal, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedProductId == product.id ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 6)
            )
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .onTapGesture { selectedProductId = product.id }
        }
}
