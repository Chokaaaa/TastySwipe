//
//  SettingsView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 22/04/2023.
//

import SwiftUI
import FirebaseAuth
import StoreKit
import MessageUI
//import RevenueCat
//import RevenueCatUI
import GoogleSignIn

struct SettingsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.requestReview) var requestReview
    @ObservedObject var purchasesManager = PurchasesManager()
    @State private var isSheetPresented = false
    @State private var isShowingPayWall = false
    @State private var showingAlert = false
    @State private var customAlert = false
    @State private var isLoginSheetPresented = false
    @State private var showingLoginView = false
    @State private var showPrivacyPolicy: Bool = false
    @State private var showTC: Bool = false
    @State var hapticIsOn = false
    
    
    @AppStorage(UserDefaultsKey.hapticEnabled) private var isHapticEnabled: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 15, bottomTrailing: 15))
                    .fill(Color("settingTopBG"))
                    .frame(width: UIScreen.main.bounds.width, height: 235)
                    .ignoresSafeArea(.container, edges: .top)
                
                VStack {
                    
                    HStack {
                        //MARK: - Back Button
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            VStack {
                                
                                Image("backButton")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 25, height: 25)
                                
                                
                            }
                            .frame(width: 50, height: 50)
                            .padding(.leading, 0)
                            .foregroundColor(Color.black.opacity(0.8))
                            //                            .background(.ultraThinMaterial, in: Circle())
                            .background(Color("smallCirclebg"), in: Circle())
                        }
                        .padding(.bottom, 100)
                        
                        Spacer()
                        
                        //MARK: - Image
                        let loggedInUser = Auth.auth().currentUser?.uid != nil
                        
                        if loggedInUser {
                            Button(action: {
                                
                            }, label: {
                                HStack(spacing: 15) {
                                    
                                    VStack {
                                        
                                        ZStack {
                                            Circle()
                                                .fill(Color.black.opacity(0.7))
                                                .frame(width: 120, height: 100)
                                            
                                            Image("userLoggedIn")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(.white)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        }
                                        
                                        VStack(alignment: .center, spacing: 5) {
                                            Text("\(sessionManager.currentUser?.fullName ?? "")")
                                                .font(.system(size: 15, weight: .bold))
                                                .foregroundStyle(.white)
                                            
                                            //                    Text(viewModel.userSession?.email ?? "No Email")
                                            Text("\(sessionManager.currentUser?.email ?? "")")
                                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                                .foregroundColor(.gray.opacity(0.8))
                                        }
                                    }
                                }
                                .padding(.leading, 0)
                            })
                            
                            
                        } else {
                            Button(action: {
                                isSheetPresented = true
                            }, label: {
                                VStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.black.opacity(0.7))
                                            .frame(width: 120, height: 100)
                                        
                                        Image("userIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.white)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .center, spacing: 5) {
                                        Text("No Name")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundStyle(.white)
                                        //                    Text(viewModel.userSession?.email ?? "No Email")
                                        Text("No Email")
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                            .foregroundColor(.gray.opacity(0.8))
                                    }
                                    
                                }
                                .padding(.leading, -55)
                            })
                        }
                            
                        
                        Spacer()
                        
                        //MARK: - Log Out Button
                        if Auth.auth().currentUser?.uid != nil {
                            Button {
                                self.customAlert = true
                            } label: {
                                VStack {
                                    
                                    Image("logoutButton")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(.white)
                                        .frame(width: 25, height: 25)
                                    
                                    
                                }
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.black.opacity(0.8))
                                //                            .background(.ultraThinMaterial, in: Circle())
                                .background(Color("smallCirclebg"), in: Circle())
                            }
                            .alert(isPresented: $customAlert) {
                                Alert(
                                    title: Text("You have successfully logged out!"),
                                    message: Text("We will miss you, Please come back as soon as possible"),
                                    dismissButton: .default(Text("Okay")) {
                                        viewModel.signOut()
                                        GIDSignIn.sharedInstance.signOut()
                                        sessionManager.currentUser = nil
                                    }
                                )
                            }
                            .padding(.bottom, 100)
                        } else {
                            
                        }
                    }
                    .padding([.leading, .trailing])
                    .padding(.bottom, 80)
                }
                .fullScreenCover(isPresented: $isSheetPresented) {
                    LoginView()
                }
            }
            ScrollView {
                VStack(spacing: 1) {
                    
                    Button {
                        
                    } label: {
                        
                        HStack(spacing: 30) {
                            
                            Image("medalIcon")
                            
                            Text("Become a PRO")
                                .font(.title2)
                                .foregroundStyle(.black)
                                .bold()
                            
                            Spacer()
                            
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                    .padding([.trailing, .leading], 10)
//                    .padding(.top,15)
                    
                    
                    
                    
                    //MARK: - General Section
                    
                    
                    Button {
                        showingAlert = true
                    } label: {
                        HStack {
                            Image("globeSettings")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Language")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Text("\(Locale.current.localizedString(forIdentifier: Locale.current.language.languageCode?.identifier ?? "No Language Settled") ?? "None")")
                                .font(.subheadline)
                                .foregroundStyle(.gray.opacity(0.6))
                            
                            
                            
                            Image("chevron.Right")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 0)
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                        
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Change App Language?"),
                            message: Text("You'll be directed to the app settings, allowing you to select your desired language."),
                            primaryButton: .default(Text("Settings")) {
                                openSettings()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .padding([.trailing, .leading], 10)
                    .padding(.top,20)
                    
                    
                    
                    NavigationLink {
                        ContactUsView()
                            .navigationBarBackButtonHidden(true)
                        
                    } label: {
                        
                        HStack {
                            Image("envelopeIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Contact Us")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Image("chevron.Right")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 0)
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                        
                    }
                    .padding([.trailing, .leading], 10)
                    
                    
                    
                    
                    
                    
                    //MARK: - Apperance
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image("sunIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Collor Scheme")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Text("Dark")
                                .font(.subheadline)
                                .foregroundStyle(.gray.opacity(0.6))
                            
                            
                            
                            Image("chevron.Right")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 0)
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                    }
                    .padding([.trailing, .leading], 10)
                    .padding(.top,30)
                    
                    //                Section {
                    //                    SettingsRowWithPicker(imageName: "circle.lefthalf.filled", text: "Color Scheme", bgColor: Color.black)
                    //                }
                    
                    //MARK: - App Related
                    
                    
                    Button {
                        requestReview()
                    } label: {
                        HStack {
                            Image("emptyStarIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Review")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Image("chevron.Right")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 0)
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                        
                    }
                    .padding([.trailing, .leading], 10)
                    .padding(.top,30)
                    
                    
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image("configIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Haptic")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isHapticEnabled)
                                .tint(Color.accentColor)
                            
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                        
                    }
                    .padding([.trailing, .leading], 10)
                    
                    //                    haptics
                    
                    //                                        .sensoryFeedback(.success, trigger: hapticIsOn)
                    
                    
                    Button {
                        showPrivacyPolicy.toggle()
                    } label: {
                        HStack {
                            Image("shieldTickIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Privacy Policy")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Image("chevron.Right")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 0)
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                        
                    }
                    .padding([.trailing, .leading], 10)
                    .padding(.top,30)
                    
                    Button {
                        showTC.toggle()
                    } label: {
                        HStack {
                            Image("taskSquareIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .padding(.leading, -10)
                            
                            
                            Text("Terms & Condition")
                                .foregroundStyle(.white)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.leading, 5)
                            
                            Spacer()
                            
                            Image("chevron.Right")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 0)
                        }
                        .padding()
                        .padding(.leading,10)
                        .background(Color("settingsRowBg"))
                        .cornerRadius(10)
                        
                    }
                    .padding([.trailing, .leading], 10)
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    //                    NavigationLink(destination: GeneralSettingsView()) {
                    //                        SettingsRow(title: "Terms & Condition", imageName: "newspaper", bgColor: Color.teal)
                    //                    }
                    
                    
                    
                }
            }
            .padding(.top, -45)
            .scrollIndicators(.hidden)
            .fullScreenCover(isPresented: $showPrivacyPolicy, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.termsfeed.com/live/57886249-1490-4e29-979f-cabc010d4b5a")!)
            })
            
            .fullScreenCover(isPresented: $showTC, content: {
                SFSafariViewWrapper(url: URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=rKSQsIUOpaoKVSGenzM4t9ph2SOPYhBu")!)
            })
            
            
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            
        }
        
        .onAppear {
            print("is Subscribed \(purchasesManager.isSubscriptionActive)")
            
        }
        
    }
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
    
    func composeEmail() {
        if let emailURL = URL(string: "nykdevs@gmail.com") {
            UIApplication.shared.open(emailURL)
        }
    }
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}

private extension SettingsView {
    var haptics: some View {
        HStack(spacing: 25) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.darkRed)
                
                HStack(spacing: 15) {
                    Image(systemName: "slider.horizontal.2.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                    
                    
                    
                    
                }
                .padding(5)
                
            }
            .frame(width: 15, height: 10)
            
            Text("Haptic")
                .font(.body)
            
            
            Toggle("", isOn: $isHapticEnabled)
                
            
        }
    }
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorSchemeManager())
    }
}


struct GeneralSettingsView: View {
    var body: some View {
        Text("General Settings")
            .navigationBarTitle("General")
    }
}

struct AccountSettingsView: View {
    var body: some View {
        Text("Account Settings")
            .navigationBarTitle("Account")
    }
}

struct NotificationsSettingsView: View {
    var body: some View {
        Text("Notifications Settings")
            .navigationBarTitle("Notifications")
    }
}
