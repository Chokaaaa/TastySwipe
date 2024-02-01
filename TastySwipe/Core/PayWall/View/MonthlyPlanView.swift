//
//  MonthlyPlanView.swift
//  MyTradingJournal
//
//  Created by James Sedlacek on 11/22/22.
//

import SwiftUI

struct MonthlyPlanView: View {
    @Binding var selectedPlan: PremiumPlan
    let plan: PremiumPlan = .monthly
    
    var body: some View {
        HStack(spacing: 16) {
            if selectedPlan == plan {
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
            
            Text("\(plan.rawValue) $" + String(format: "%.2f", plan.cost))
                .font(.system(size: 17, weight: .semibold))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .padding(.horizontal, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedPlan == plan ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 6)
        )
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .onTapGesture { selectedPlan = plan }
    }
}

struct MonthlyPlanView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPlanView(selectedPlan: .constant(.yearly))
    }
}
