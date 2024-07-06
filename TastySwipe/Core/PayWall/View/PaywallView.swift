//
//  PaywallView.swift
//  MyTradingJournal
//
//  Created by James Sedlacek on 11/22/22.
//

import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var purchasesManager : PurchasesManager
//    @State private var selectedPlan: PremiumPlan = .yearly
    let iPhone14ProMaxScreenSize: CGSize = CGSize(width: 430.0, height: 932.0)
    let screenSize: CGSize = UIScreen.main.bounds.size
    
    @State private var selectedProductId : String = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showPurchaseLoading = false
    @State private var showPrivacyPolicy: Bool = false
    @State private var showTC: Bool = false
    
    var body: some View {
        
        ZStack {
            ZStack {
                VStack(spacing: 5) {
                    Text("Become a PRO")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            Text("Block Ads 🚫")
                                .font(.system(size: 17.5, weight: .bold))
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                        .padding(.leading,25)
                        
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            Text("Unlimited Access ✅")
                                .font(.system(size: 17.5, weight: .bold))
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                        .padding(.leading,25)
                        
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            Text("Get More features 🍱")
                                .font(.system(size: 17.5, weight: .bold))
                                .foregroundStyle(Color.black)
                            Spacer()
                        }
                        .padding(.leading,25)
                        
                        
                    }
                    .padding([.top,.bottom], 10)
                    
                    //                Text("Generate unlimited routes Unlock all content.\nRemove all ads.")
                    //                    .font(.system(size: 15, weight: .bold))
                    //                    .multilineTextAlignment(.center)
                    
                    choosePlanSection()
                    //                    .padding(.top, 15)
                        .padding(.horizontal, 10)
                    actionButton()
                        .padding(.top, 15)
                    
                    
                    
                    HStack {
                        
                        Button {
                            showPrivacyPolicy.toggle()
                        } label: {
                            Text("Privacy Policy")
                                .font(.system(size: 12, weight: .medium))
                        }
                        
                        
                        Divider()
                            .frame(height: 50)
                        
                        Button {
                            showTC.toggle()
                        } label: {
                            Text("Terms of Use")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .padding([.leading, .trailing], 15)
                        
                        Divider()
                            .frame(height: 50)
                        restorePurchasesButton()
                        
                        
                        
                    }
                    .padding(.top, 5)
                    .padding(.leading, 10)
                    
                    
                }
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .center)
                .cornerRadius(20)
                .padding(.horizontal, 85)
                .blur(radius: 0.25)
                .padding(.bottom, -580)
                .zIndex(1)
                
                VStack(alignment: .center, spacing: 16) {
                    carouselSection()
                    
                }
                .scaleEffect(CGSize(width: screenSize.width / iPhone14ProMaxScreenSize.width,
                                    height: screenSize.height / iPhone14ProMaxScreenSize.height))
                .padding(.vertical, isIPhone14ProMax() ? 0 : -20)
                
                VStack {
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                        .frame(height: 500)
                        .padding(.horizontal)
                        .blur(radius: 30)
                        .padding(.bottom, -60)
                }
            }
            
            if showPurchaseLoading {
                Color.clear.ignoresSafeArea().background(
                    
                    .ultraThinMaterial
                    
                )
                VStack(alignment: .center, spacing: 15) {
                    
                    Text("Loading...")
                    
                    ProgressView()
                }
            }
            
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button {
                
            } label: {
                Text("Okay")
            }

        }, message: {
            Text(alertMessage)
        })
        .fullScreenCover(isPresented: $showPrivacyPolicy, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.termsfeed.com/live/57886249-1490-4e29-979f-cabc010d4b5a")!)
        })
        
        .fullScreenCover(isPresented: $showTC, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=rKSQsIUOpaoKVSGenzM4t9ph2SOPYhBu")!)
        })
        .ignoresSafeArea()
    }
    
    
    
    private func carouselSection() -> some View {
        return VStack {
            
            HStack {
                InfiniteScroller(contentWidth: 0, contentHeight: getContentHeight(), direction: .forward) {
                    VStack(spacing: 16) {
                        FeatureCardView(featureCard: .unlimitedEntries)
                        FeatureCardView(featureCard: .food9)
                        FeatureCardView(featureCard: .food13)
                        FeatureCardView(featureCard: .food17)
                        
                        
                    }.padding(5)
                }
                InfiniteScroller( contentWidth: 0, contentHeight : getContentHeight(), direction: .backward) {
                    VStack(spacing: 16) {
                        FeatureCardView(featureCard: .customTags)
                        FeatureCardView(featureCard: .moreStats)
                        FeatureCardView(featureCard: .moreDates)
                        FeatureCardView(featureCard: .unlimitedGoals)
                    }.padding(5)
                }
                
                InfiniteScroller(contentWidth: 0, contentHeight: getContentHeight(), direction: .forward) {
                    VStack(spacing: 16) {
                        FeatureCardView(featureCard: .food10)
                        FeatureCardView(featureCard: .food11)
                        FeatureCardView(featureCard: .food12)
                        FeatureCardView(featureCard: .importData)
                    }.padding(5)
                }
                InfiniteScroller(contentWidth: 0, contentHeight: getContentHeight(), direction: .backward) {
                    VStack(spacing: 16) {
                        FeatureCardView(featureCard: .food14)
                        FeatureCardView(featureCard: .biometricsLock)
                        FeatureCardView(featureCard: .food15)
                        FeatureCardView(featureCard: .food16)
                    }.padding(5)
                }
                InfiniteScroller(contentWidth: 0, contentHeight: getContentHeight(), direction: .forward) {
                    VStack(spacing: 16) {
                        FeatureCardView(featureCard: .food18)
                        FeatureCardView(featureCard: .food19)
                        FeatureCardView(featureCard: .automaticBackups)
                        FeatureCardView(featureCard: .food20)
                    }.padding(5)
                }
            }
            .overlay {
                Button {
                    dismiss()
                } label: {
                    dismissButton()
                }
                .position(x: 115, y: 70)
            }
        }
    }
    
    
    private func choosePlanSection() -> some View {
        return VStack(alignment: .center, spacing: 10) {
            
            ForEach(purchasesManager.products) { product in
                
                PlanView(product: product, selectedProductId: $selectedProductId)
                
            }
            
            
//            MonthlyPlanView(selectedPlan: $selectedPlan).padding(.bottom)
//            YearlyPlanView(selectedPlan: $selectedPlan).padding(.bottom)
        }
    }
    
    private func actionButton() -> some View {
        return Button {
            showPurchaseLoading = true
            purchasesManager.purchasePremiumSubscription(identifier: selectedProductId) { success, error in
                showPurchaseLoading = false
                //MARK: - Alert
                if let error = error {
                    print("Error is \(error)")
                }
            }
        } label: {
            Text(selectedProductId == "$rc_monthly" ? "Start Free Trial" : "Continue")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(15)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.horizontal, 25)
        }
    }
    
    private func restorePurchasesButton() -> some View {
        return Button {
            purchasesManager.restorePurchases { success in
                //MARK: - if success put allert no need 
            }
        } label: {
            Text("Restore Purchases")
                .font(.system(size: 12, weight: .medium))
        }
    }
    
    
    private func getContentHeight() -> CGFloat {
        let cardheight: CGFloat = 90
        let spacing: CGFloat = 16
        let padding: CGFloat = 8
        let contentHeight: CGFloat = (cardheight * 4) + (spacing * 9) + padding
        return contentHeight
    }
    
    private func isIPhone14ProMax() -> Bool {
        return screenSize == iPhone14ProMaxScreenSize
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
            .environmentObject(PurchasesManager())
    }
}
