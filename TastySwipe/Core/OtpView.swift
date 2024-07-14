//
//  SwiftUIView.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 13/07/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OtpView: View {
    
    @AppStorage("isOnboarding") var isOnboarding = true
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var loginNavigationManager: LoginNavigationManager
    @State private var timeRemaining: Int = 59
    @State private var timerRunning: Bool = true
    @State private var otpText = ""
    @State private var otpDigits: [Int] = []
    @State private var newTextValue = ""
    @State private var otpOne = ""
    @State private var otpTwo = ""
    @State private var otpThree = ""
    @State private var otpFour = ""
    @State private var otpFive = ""
    @State private var otpSix = ""
    var phoneNumber: String = ""
    
    let verificationDetails: VerificationDetails
    var circleWidth : CGFloat {
        let viewWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 7 * 10
        return (viewWidth - spacing) / 6
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if !isOnboarding {
                        dismiss()
                    } else {
                        isOnboarding = false
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 15)
                }
                Spacer()
            }
            .padding(.vertical)
            
            
            HStack {
                Spacer()
                Text("Enter authentication code")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                Spacer()
            }
            
            Text("Enter the 6-digit that we have sent via the phone number \(phoneNumber)")
                .font(.system(size: 20, weight: .thin))
                .padding()
            
            
            ZStack {
                
                HStack(spacing: 10) {
                    // First Circle with number 5
                    Circle()
                        .stroke(otpOne.isEmpty ? Color("otpCirclInnactiveColor") : Color.white, lineWidth: 2)
                        .frame(width: circleWidth)
                        .overlay(
                            Text(otpOne)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                    
                    // Second Circle with number 1
                    Circle()
                        .stroke(otpTwo.isEmpty ? Color("otpCirclInnactiveColor") : Color.white, lineWidth: 2)
                        .frame(width: circleWidth)
                        .overlay(
                            Text(otpTwo)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                    
                    Circle()
                        .stroke(otpThree.isEmpty ? Color("otpCirclInnactiveColor") : Color.white, lineWidth: 2)
                        .frame(width: circleWidth)
                        .overlay(
                            Text(otpThree)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                    
                    Circle()
                        .stroke(otpFour.isEmpty ? Color("otpCirclInnactiveColor") : Color.white, lineWidth: 2)
                        .frame(width: circleWidth)
                        .overlay(
                            Text(otpFour)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                    
                    Circle()
                        .stroke(otpFive.isEmpty ? Color("otpCirclInnactiveColor") : Color.white, lineWidth: 2)
                        .frame(width: circleWidth)
                        .overlay(
                            Text(otpFive)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                    
                    Circle()
                        .stroke(otpSix.isEmpty ? Color("otpCirclInnactiveColor") : Color.white, lineWidth: 2)
                        .frame(width: circleWidth)
                        .overlay(
                            Text(otpSix)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        )
                }
                
                .padding(.horizontal, 10)
                .background(Color.black.edgesIgnoringSafeArea(.all))
                
                //MARK: - Textfield
                OTPTextField(value: $otpText, newOtpDigitAction: { otpValue in
                    guard let otpDigit = Int(otpValue),
                          otpDigits.count < 6 else { return }
                    otpDigits.append(otpDigit)
                    otpOne = ""
                    otpTwo = ""
                    otpThree = ""
                    otpFour = ""
                    otpFive = ""
                    otpSix = ""
                    for (index, digit) in otpDigits.enumerated() {
                        if index + 1 == 1 {
                            otpOne = "\(digit)"
                        } else if index + 1 == 2 {
                            otpTwo = "\(digit)"
                        } else if index + 1 == 3 {
                            otpThree = "\(digit)"
                        } else if index + 1 == 4 {
                            otpFour = "\(digit)"
                        } else if index + 1 == 5 {
                            otpFive = "\(digit)"
                        } else if index + 1 == 6 {
                            otpSix = "\(digit)"
                        }
                    }
                }, backSpaceAction: {
                   let _ = otpDigits.popLast()
                    otpOne = ""
                    otpTwo = ""
                    otpThree = ""
                    otpFour = ""
                    otpFive = ""
                    otpSix = ""
                    for (index, digit) in otpDigits.enumerated() {
                        if index + 1 == 1 {
                            otpOne = "\(digit)"
                        } else if index + 1 == 2 {
                            otpTwo = "\(digit)"
                        } else if index + 1 == 3 {
                            otpThree = "\(digit)"
                        } else if index + 1 == 4 {
                            otpFour = "\(digit)"
                        } else if index + 1 == 5 {
                            otpFive = "\(digit)"
                        } else if index + 1 == 6 {
                            otpSix = "\(digit)"
                        }
                    }
                })
            }
            .padding(.vertical)
        
            
            
            Button {
                verifyOTP()
            } label: {
                Text("Login")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical,20)
                    .frame(maxWidth: .infinity)
                    .background {
                        //                        if email.count <= 0 {
                        //                        Capsule()
                        //                            .fill(Color("innactiveButtonColorDarkBlue"))
                        //                        } else {
                        Capsule()
                            .fill(Color.accentColor)
                        //                        }
                    }
                    .padding(.horizontal,0)
            }
            .padding(.top, 20)
            
            
            
            Text("\(timeString(time: timeRemaining))")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .onAppear {
                    startTimer()
                }
                .padding(.top)
            
            Button {
                
            } label: {
                Text("Resend Code")
                    .font(.title3)
                    .padding()
                    .foregroundColor(timeRemaining == 0 ? Color.accentColor : Color("innactiveButtonColorDarkBlue"))
            }
            .disabled(timeRemaining != 0)
         
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    func timeString(time: Int) -> String {
        let minutes = String(format: "%02d", time / 60)
        let seconds = String(format: "%02d", time % 60)
        return "\(minutes) : \(seconds)"
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer.invalidate()
                self.timerRunning = false
            }
        }
    }
    
    func verifyOTP() {
//            let otpCode = "\(otpOne)\(otpTwo)\(otpThree)\(otpFour)\(otpFive)\(otpSix)"
        
        let otpCode = otpDigits.map( { String($0) } ).joined()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationDetails.code, verificationCode: otpCode)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
//                    showError = true
//                    errorMessage = error.localizedDescription
                    return
                }
                
                guard let userId = Auth.auth().currentUser?.uid else { return }
                
                let user = User(fullName: "", uid: userId, email: nil, phoneNumber: verificationDetails.phoneNumber)
                
                do {
                    let encodedUser = try Firestore.Encoder().encode(user)
                    Firestore.firestore().collection("users").document(userId).setData(encodedUser) { error in
                        if let error = error {
                            return
                        }
                        sessionManager.currentUser = user
//                        sessionManager.fetchLoggedIn(userId: userId)
                        loginNavigationManager.showOTPView = false
                        loginNavigationManager.showLoginView = false
                    }
                } catch {
                    
                }
                
             
              
                
                // User successfully signed in
//                showSuccess = true
//                showError = false
            }
        }
    
}

#Preview {
    OtpView(loginNavigationManager: LoginNavigationManager(), verificationDetails: VerificationDetails(code: "1234", phoneNumber: "+971554258496"))
}
