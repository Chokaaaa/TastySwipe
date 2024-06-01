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
        HStack(spacing: 7) {
            if selectedPlan == plan {
                Image.checkmarkCircleIcon
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.accentColor)
            } else {
                Image.circleIcon
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.accentColor)
            }
                  
            HStack(spacing: 110) {
                
                Text("7-day free trial")
//                    .padding(.leading, -10)
                
                
                Text( "$" + String(format: "%.2f", plan.cost) + "/month")
                
            }
            
//            Text("\(plan.rawValue) $" + String(format: "%.2f", plan.cost))
                .font(.system(size: 14, weight: .semibold))
//            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 55)
//        .padding(.horizontal, 5)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedPlan == plan ? Color.accentColor : Color.gray.opacity(0.5), lineWidth: 2.5)
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
