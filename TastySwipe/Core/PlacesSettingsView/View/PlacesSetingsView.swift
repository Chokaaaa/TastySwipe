//
//  PlacesSetingsView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 05/07/2024.
//

import SwiftUI
import ModernSlider

struct PlacesSetingsView: View {
    
    let spacing: CGFloat = 10
    let padding: CGFloat = 10
    
    var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - (spacing * 2) - (padding * 2)) / 5
    }
    
    @Environment(\.dismiss) var dismiss
    @State private var distance: Double = 0
    @EnvironmentObject var homeViewModel : HomeViewModel
    @AppStorage("filterByRating") var filterByRating = 1
    @AppStorage("searchRadius") var searchRadius = 1000
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                
                Text("Filter")
                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                }
                
            }
            .padding([.leading, .trailing], 15)
            .padding(.bottom)
            
            
            
            Text("By Rating")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                
                .padding()
            
            HStack {
                
                Button {
                    filterByRating = 1
                } label: {
                    if filterByRating >= 1 {
                        Image("filledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    } else {
                        Image("unfilledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    }
                }
                
                
                Button {
                    filterByRating = 2
                } label: {
                    if filterByRating >= 2 {
                        Image("filledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    } else {
                        Image("unfilledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    }
                }
                
                
                Button {
                    filterByRating = 3
                } label: {
                    if filterByRating >= 3 {
                        Image("filledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    } else {
                        Image("unfilledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    }
                }
                
                
                Button {
                    filterByRating = 4
                } label: {
                    if filterByRating >= 4 {
                        Image("filledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    } else {
                        Image("unfilledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    }
                }
                
                
                Button {
                    filterByRating = 5
                } label: {
                    if filterByRating >= 5 {
                        Image("filledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    } else {
                        Image("unfilledRatingStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemWidth, height: itemWidth)
                    }
                }
                
              
                
                
            }
            
            Spacer()
            
            Text("By Radius")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .padding([.leading, .trailing], 15)
            
//            Slider(value: $celsius, in: -100...100)
            
            VStack(alignment: .center) {
                
                ModernSlider(
                    systemImage: "eye.circle",
                    sliderWidth: UIScreen.main.bounds.width - 30,
                    sliderHeight: 30,
                    sliderColor: .accentColor,
                    value: $distance
                )
                
                
                HStack {
                    
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 2.5, height: 15)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("1KM")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 2.5, height: 15)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("2KM")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 2.5, height: 15)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("4KM")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 2.5, height: 15)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("6KM")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 2.5, height: 15)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("8KM")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 2.5, height: 15)
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("10KM")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    
                }
                .padding(.horizontal, 9)
            }
            Spacer()
            
            HStack {
                
                Button {
                    filterByRating = 1
                    searchRadius = 10000
                } label: {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding(.vertical,20)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(Color.gray)
                        }
                        .padding(.horizontal,20)
                }
                
                
                Button {
                    homeViewModel.fetchByRating(rating: filterByRating)
                    dismiss()
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding(.vertical,20)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .fill(Color.accentColor)
                        }
                        .padding(.horizontal,20)
                }
                
            }
            
            
        }
        .padding()
        
        .onAppear {
            distance = (Double(searchRadius) / Double(10000)) * 100
        }
        
        .onChange(of: distance) { oldValue, newValue in
            print("Current distance \(newValue)")
            
            if newValue <= 10 {
                searchRadius = 1000
            } else {
                searchRadius = Int((Double(newValue) / Double(100)) * 10000)
            }
            
            
        }
        
    }
}

#Preview {
    PlacesSetingsView()
}
