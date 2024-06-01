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
        
            HStack(spacing: 10) {
                if selectedProductId == product.id {
                    Image.checkmarkCircleIcon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.accentColor)
                } else {
                    Image.circleIcon
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Text("\(product.name)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Text("\(product.price)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.black)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .padding(.horizontal, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedProductId == product.id ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 2.5)
            )
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 15)
            .onTapGesture { selectedProductId = product.id }
            .onAppear{
                selectedProductId = product.id
            }
        }
}

//
//struct PaywallView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaywallView()
//            .environmentObject(PurchasesManager())
//    }
//}
