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
import RevenueCat
import RevenueCatUI
import GoogleSignIn

struct SettingsView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var sessionManager: SessionManager
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
            
            
            List {
                
                Section {
                    
                    if Auth.auth().currentUser?.uid != nil {
                        Button(action: {
                            
                        }, label: {
                            HStack(spacing: 15) {
                                Image("PF.Changs")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(
                                        Circle()
                                    )
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(sessionManager.currentUser?.fullName ?? "")")
                                        .font(.system(size: 15, weight: .bold))
                                    
                                    //                    Text(viewModel.userSession?.email ?? "No Email")
                                    Text("\(sessionManager.currentUser?.email ?? "")")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color.red)
                                }
                                
                            }
                            .padding(.leading, -10)
                        })
                        
                        
                    } else {
                        Button(action: {
                            isSheetPresented = true
                        }, label: {
                            HStack(spacing: 15) {
                                Image("loading")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(
                                        Circle()
                                    )
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("No Name")
                                        .font(.system(size: 15, weight: .bold))
                                    
                                    //                    Text(viewModel.userSession?.email ?? "No Email")
                                    Text("No Email")
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color.red)
                                }
                                
                                Spacer()
                                
                                Image(systemName : "chevron.right")
                                    .foregroundStyle(Color.secondary)
                                    .opacity(0.5)
                                    .font(.system(size: 14, weight: .bold))
                                
                            }
                            .padding(.leading, -10)
                        })
                    }
                    
                }
                .fullScreenCover(isPresented: $isSheetPresented) {
                    LoginView()
                }
                
                //MARK: - General Section
                Section {
                    
                    NavigationLink(destination: PlacesListView()) {
                        SettingsRow(title: "Categories", imageName: "square.grid.2x2", bgColor: Color.pink)
                    }
                    
                    
                    Button {
                        showingAlert = true
                    } label: {
                        HStack {
                            SettingsRow(title: "Language", imageName: "globe", bgColor: Color.blue)
                                .foregroundStyle(Color("SystemTextColor"))
                            Spacer()
                            
                            Text("\(Locale.current.localizedString(forIdentifier: Locale.current.language.languageCode?.identifier ?? "No Language Settled") ?? "None")")
                                .foregroundStyle(.gray)
                            
                            Image(systemName : "chevron.right")
                                .foregroundStyle(Color.secondary)
                                .opacity(0.5)
                                .font(.system(size: 14, weight: .bold))
                        }
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
                    
                    Button(action: {
                        EmailController.shared.sendEmail(subject: "Support",
                                                         body: """
      Please describe your issue below
  
  
  
    ---------------------------------------
    Application Name: \(Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Unknown")
    iOS Version: \(UIDevice.current.systemVersion)
    Device Model: \(UIDevice.current.model)
    App Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "no app version")
    App Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "no app build version")
  """,
                                                         to: "nykdevs@gmail.com")
                    }, label: {
                        SettingsRow(title: "Contact Us", imageName: "envelope.open", bgColor: Color.cyan)
                            .foregroundStyle(Color("SystemTextColor"))
                    })
                    
                    
                    
                }
                
                
                //MARK: - Apperance
                Section {
                    SettingsRowWithPicker(imageName: "circle.lefthalf.filled", text: "Color Scheme", bgColor: Color.black)
                }
                
                //MARK: - App Related
                Section {
                    
                    Button(action: {
                        requestReview()
                    }, label: {
                        SettingsRow(title: "Review", imageName: "star", bgColor: Color.yellow)
                            .foregroundStyle(Color("SystemTextColor"))
                    })

                    
                    haptics
                    
//                    .sensoryFeedback(.success, trigger: hapticIsOn)
                    
                    
                }
                
                
                Section {
                    
                    
                    Button {
                        showPrivacyPolicy.toggle()
                        
                    } label: {
                        SettingsRow(title: "Privacy Policy", imageName: "shield.lefthalf.filled", bgColor: Color.teal)
                            .foregroundStyle(Color("SystemTextColor"))
                    }
                    
                    Button {
                        showTC.toggle()
                        
                    } label: {
                        SettingsRow(title: "Terms & Condition", imageName: "newspaper", bgColor: Color.cyan)
                            .foregroundStyle(Color("SystemTextColor"))
                    }
                    
//                    NavigationLink(destination: GeneralSettingsView()) {
//                        SettingsRow(title: "Terms & Condition", imageName: "newspaper", bgColor: Color.teal)
//                    }
                }
                
                //MARK: - Log Out
                
                if Auth.auth().currentUser?.uid != nil {
                    Section {
                        
                        Button {
                            self.customAlert = true
                        } label: {
                            SettingsRow(title: "Log Out", imageName: "rectangle.portrait.and.arrow.right", bgColor: Color.red)
                                .foregroundStyle(Color("SystemTextColor"))
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
                    }
                }
                
            }
            .fullScreenCover(isPresented: $showPrivacyPolicy, content: {
                    SFSafariViewWrapper(url: URL(string: "https://www.termsfeed.com/live/57886249-1490-4e29-979f-cabc010d4b5a")!)
            })
            
            .fullScreenCover(isPresented: $showTC, content: {
                    SFSafariViewWrapper(url: URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=rKSQsIUOpaoKVSGenzM4t9ph2SOPYhBu")!)
            })
            
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    HStack {
                        
                        if purchasesManager.isSubscriptionActive == false {
                            Button {
                                isShowingPayWall = true
                            } label: {
                                HStack(spacing: 0) {
                                    Text("💎")
                                        .foregroundStyle(Color.yellow)
                                        .frame(width: 25, height: 0)
                                    Text("PRO")
                                        .fontWeight(.bold)
                                }
                                .padding(5)
                                .foregroundColor(.white)
                                .background(Color.accentColor)
                                .clipShape(
                                    Capsule()
                                )
                            }
                            .fullScreenCover(isPresented: $isShowingPayWall) {
                                PaywallView()
                                    .padding([.leading, .trailing], -100)
//                                    .paywallFooter(condensed: false)
                            }
                            
                        } else {
                            
                            
                            
                        }
//                        Button {
//                            
//                            if Auth.auth().currentUser?.uid == nil {
//                                showingLoginView.toggle()
//                            } else {
//                                //MARK: - Login to open a view for whatsapp share
//                                
//                            }
//                            
//                        } label: {
//                            Image(systemName: "person.3")
//                                .foregroundStyle(Color.accentColor)
//                        }
                    }
                    .fullScreenCover(isPresented: $showingLoginView) {
                        LoginView()
                    }
                }
            }
           
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
