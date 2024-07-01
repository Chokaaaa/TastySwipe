////
////  OnBoardingScreen.swift
////  AnimatedOnBoardingScreen
////
////  Created by Balaji on 17/12/22.
////
//
//import SwiftUI
////import Lottie
//
//struct OnBoardingScreen: View {
//    @AppStorage("isOnboarding") var isOnboarding : Bool = false
//    
//    // MARK: OnBoarding Slides Model Data
//    @State var onboardingItems: [OnBoardingItem] = [
//        .init(title: "Welcome to",
//              focusWord: "Locale Link 👋", subTitle: "Discover the ultimate app for locating incredible dining experiences and delicious cuisine with a single swipe!",
//              lottieView: .init(name: "options",bundle: .main)),
//        .init(title: "Get ready to",
//              focusWord: "explore😋", subTitle: "Uncover top-notch eateries in your vicinity with a simple swipe! Glide right to bookmark your favorites, and left to skip.",
//              lottieView: .init(name: "map",bundle: .main)),
//        .init(title: "Big list of",
//              focusWord: "choice🤤", subTitle: "Effortlessly glide through our handpicked assortment of choices, connecting with options that perfectly align with your palate, all with a single swipe!",
//              lottieView: .init(name: "thinking",bundle: .main))
//        
//    ]
//    @State private var showingLoginView = false
//    @EnvironmentObject var authViewModel : AuthViewModel
//    @EnvironmentObject var sessionManager : SessionManager
//    // MARK: Current Slide Index
//    @State var currentIndex: Int = 0
//    
//    @State var showLogin = false
//    
//    var body: some View {
//        GeometryReader{
//            let size = $0.size
//            
//            HStack(spacing: 0){
//                ForEach($onboardingItems) { $item in
//                    let isLastSlide = (currentIndex == onboardingItems.count - 1)
//                    VStack{
//                        // MARK: Top Nav Bar
//                        HStack{
//                            Button("Back"){
//                                if currentIndex > 0{
//                                    currentIndex -= 1
//                                    playAnimation()
//                                }
//                            }
//                            .opacity(currentIndex > 0 ? 1 : 0)
//                            
//                            Spacer(minLength: 0)
//                     
//                        }
//                        .animation(.easeInOut, value: currentIndex)
//                        .tint(Color.accentColor)
//                        .fontWeight(.bold)
//                        
//                        // MARK: Movable Slides
//                        VStack(spacing: 15){
//                            
//                            
//                            
//                            
//                            let offset = -CGFloat(currentIndex) * size.width
//                            // MARK: Resizable Lottie View
//                            ResizableLottieView(onboardingItem: $item)
//                                .frame(height: size.width)
//                                .onAppear {
//                                    // MARK: Intially Playing First Slide Animation
//                                    if currentIndex == indexOf(item){
//                                        item.lottieView.play(toProgress: 0.7)
//                                    }
//                                }
//                                .offset(x: offset)
//                                .animation(.easeInOut(duration: 0.5), value: currentIndex)
//                            
//                            HStack {
//                                Text(item.title)
//                                    .font(.title.bold())
//                                    .offset(x: offset)
//                                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)
//                                
//                                Text(item.focusWord)
//                                    .font(.title.bold())
//                                    .foregroundColor(Color.accentColor)
//                                    .offset(x: offset)
//                                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: currentIndex)
//                                
//                            }
//                                
//                            Text(item.subTitle)
//                                .font(.system(size: 14))
//                                .multilineTextAlignment(.center)
//                                .padding(.horizontal,15)
//                                .foregroundColor(.gray)
//                                .offset(x: offset)
//                                .animation(.easeInOut(duration: 0.5).delay(0.2), value: currentIndex)
//                            
//                            PageIndicator(currentIndex: currentIndex, pageCount: onboardingItems.count)
//                                .padding(.bottom, 10)
//                            
//                        }
//                        .gesture(
//                                DragGesture(minimumDistance: 10)
//                                    .onEnded(onDragEnded)
//                            )
//                        
//                        Spacer(minLength: 0)
//                        
//                        // MARK: Next / Login Button
//                        VStack(spacing: 15){
//                            
//                            Button {
//                                // MARK: Updating to Next Index
//                                if currentIndex < onboardingItems.count - 1{
//                                    // MARK: Pausing Previous Animation
//                                    let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
//                                    onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
//                                    currentIndex += 1
//                                    // MARK: Playing Next Animation from Start
//                                    playAnimation()
//                                } else if isLastSlide {
//                                    isOnboarding = false
////                                    isOnboarding = false
//                                }
//                            } label: {
//                                Text(isLastSlide ? "Start" : "Next")
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//    //                                .padding(.vertical,isLastSlide ? 13 : 12)
//                                    .padding(.vertical,15)
//                                    .frame(maxWidth: .infinity)
//                                    .background {
//                                        Capsule()
//                                            .fill(Color.accentColor)
//                                    }
//    //                                .padding(.horizontal,isLastSlide ? 30 : 100)
//                                    .padding(.horizontal,20)
//                            }
//
//                            Button {
//                                if !isLastSlide {
//                                    showLogin = false
//                                    currentIndex = onboardingItems.count - 1
//                                    playAnimation()
//                                }
//                                if isLastSlide {
//                                    showLogin = true
////                                    isOnboarding = false
//                                }
//                            } label: {
//                                Text(isLastSlide ? "Login" : "Skip")
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color.accentColor)
//    //                                .padding(.vertical,isLastSlide ? 13 : 12)
//                                    .padding(.vertical,15)
//                                    .frame(maxWidth: .infinity)
//                                    .background {
//                                        Capsule()
//                                            .fill(Color("bgButton"))
//                                    }
//    //                                .padding(.horizontal,isLastSlide ? 30 : 100)
//                                    .padding(.horizontal,20)
//                            }
//                            
//                            HStack{
//                                Text("Terms of Service")
//                                    
//                                Text("Privacy Policy")
//                            }
//                            .font(.caption2)
//                            .underline(true, color: .primary)
//                            .offset(y: 5)
//                        }
//                    }
//                    .fullScreenCover(isPresented: $showingLoginView) {
//                        LoginView()
//                    }
//                    .animation(.easeInOut, value: isLastSlide)
//                    .padding(15)
//                    .frame(width: size.width, height: size.height)
//                }
//            }
//            .frame(width: size.width * CGFloat(onboardingItems.count),alignment: .leading)
//        }
//        .fullScreenCover(isPresented: $showLogin) {
//            LoginView()
//        }
//    }
//    
//    
//    func playAnimation(){
//        onboardingItems[currentIndex].lottieView.currentProgress = 0
//        onboardingItems[currentIndex].lottieView.play(toProgress: 0.7)
//    }
//    
//    // MARK: Retreving Index of the Item in the Array
//    func indexOf(_ item: OnBoardingItem)->Int{
//        if let index = onboardingItems.firstIndex(of: item){
//            return index
//        }
//        return 0
//    }
//    
//    func onDragEnded(drag: DragGesture.Value) {
//        let screenWidth = UIScreen.main.bounds.width
//        let translation = drag.translation.width
//        
//        if translation > screenWidth * 0.3 {
//            // Swipe Right
//            if currentIndex > 0 {
//                currentIndex -= 1
//                playAnimation()
//            }
//        } else if -translation > screenWidth * 0.3 {
//            // Swipe Left
//            if currentIndex < onboardingItems.count - 1 {
//                let currentProgress = onboardingItems[currentIndex].lottieView.currentProgress
//                onboardingItems[currentIndex].lottieView.currentProgress = (currentProgress == 0 ? 0.7 : currentProgress)
//                currentIndex += 1
//                playAnimation()
//            }
//        }
//    }
//    
//}
//
//struct OnBoardingScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        OnBoardingScreen()
//    }
//}
