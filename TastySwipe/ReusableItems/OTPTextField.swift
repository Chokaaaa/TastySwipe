//
//  otpTextField.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 14/07/2024.
//

import Foundation
import SwiftUI

struct OTPTextField: UIViewRepresentable {
    
    @Binding var value: String
    var newOtpDigitAction: (_ otpValue: String) -> Void
    var backSpaceAction: () -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 35)
        textField.tintColor = UIColor.clear
        textField.textColor = UIColor.clear
        textField.delegate = context.coordinator
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
//        uiView.text = value
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(value: $value, newOtpDigitAction: newOtpDigitAction, backSpaceAction: backSpaceAction)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var value: String
        var newOtpDigitAction: (_ otpValue: String) -> Void
        var backSpaceAction: () -> Void
        
        init(value: Binding<String>, newOtpDigitAction: @escaping (_ otpValue: String) -> Void, backSpaceAction: @escaping () -> Void ) {
            self._value = value
            self.newOtpDigitAction = newOtpDigitAction
            self.backSpaceAction = backSpaceAction
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            print("replacement text \(string)")
            if string.isEmpty {
                print("text is empty")
                backSpaceAction()
                return true
            }
            if Int(string) != nil {
                
//                value = textField.text ?? ""
                
                
                
                newOtpDigitAction(string)
                return true
            }
            print("invalid string")
            return false
        }
        
    }
    
}
