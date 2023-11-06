//
//  MoneyTextField.swift
//  Floney
//
//  Created by 남경민 on 2023/09/14.
//

import Foundation
import UIKit
import SwiftUI
struct MoneyTextField: UIViewRepresentable {
    let scaler = Scaler.shared
    @Binding var text: String
    var placeholder: String
    
    var keyboardType: UIKeyboardType = .decimalPad
    var alignment: NSTextAlignment = .left  // 새로운 정렬 속성 추가
    
    var textFont: UIFont {
        .pretendardFont(.bold, size: scaler.scaleWidth(38))
    }
    var textColor: UIColor = .primary2
    
    var placeholderFont: UIFont {
        .pretendardFont(.bold, size:scaler.scaleWidth(36))
    }
    var placeholderColor: UIColor = .greyScale9
    
    var backgroundColor: UIColor = .clear

    
    func makeUIView(context: Context) -> UITextField {
        let textField = MoneyFixedSizeTextField()//UITextField()
        textField.delegate = context.coordinator
        
        // '원' 레이블 생성
        let wonLabel = UILabel()
        wonLabel.text = CurrencyManager.shared.currentCurrency
        wonLabel.font = textFont
        wonLabel.textColor = textColor
        wonLabel.sizeToFit()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: placeholderColor,
            NSAttributedString.Key.font: placeholderFont
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textField.font = textFont
        textField.textColor = textColor
        // 키보드 타입 설정
        textField.keyboardType = keyboardType
        // 텍스트 정렬 설정
        textField.textAlignment = alignment  // 정렬 속성 적용
        textField.rightView = wonLabel
        
        textField.rightViewMode = .whileEditing
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.backgroundColor = backgroundColor
        if let text = uiView.text {
            if !text.isEmpty {
                uiView.rightViewMode = .always
            }
            else {
                uiView.rightViewMode = .never
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: MoneyTextField
        
        init(_ parent: MoneyTextField) {
            self.parent = parent
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            // 문자열에서 숫자만 추출하고, 자릿수 확인
            let digits = textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? ""
            if digits.count >= 11 { // 100억 이상일 때 (11자리 이상)
                // 36pt와 자간 -1%
                let fontSize: CGFloat = 36
                let kernValue: CGFloat = -0.01 * fontSize
                applyFontAttributes(to: textField, fontSize: fontSize, kernValue: kernValue)
            } else { // 10억 이하일 때
                // 38pt와 자간 0
                let fontSize: CGFloat = 38
                applyFontAttributes(to: textField, fontSize: fontSize, kernValue: 0)
            }
            parent.text = textField.text ?? ""
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            // 문자열에서 숫자만 추출하고, 자릿수 확인
            let digits = textField.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? ""
            if digits.count >= 11 { // 100억 이상일 때 (11자리 이상)
                // 36pt와 자간 -1%
                let fontSize: CGFloat = 36
                let kernValue: CGFloat = fontSize * -0.01
                applyFontAttributes(to: textField, fontSize: fontSize, kernValue: kernValue)
            } else { // 10억 이하일 때
                // 38pt와 자간 0
                let fontSize: CGFloat = 38
                applyFontAttributes(to: textField, fontSize: fontSize, kernValue: 0)
            }
    
            
            parent.text = textField.text ?? ""
            
            // '원' 레이블의 위치 업데이트
            if let rightView = textField.rightView as? UILabel {
                rightView.sizeToFit()
                
                // 텍스트 필드의 내용 영역을 얻습니다.
                let contentRect = textField.textRect(forBounds: textField.bounds)
                
                // "원" 레이블의 x 위치를 텍스트 필드의 내용 영역의 너비로 설정합니다.
                var xPosition = contentRect.width
                rightView.frame = CGRect(x: xPosition, y: 0, width: rightView.frame.width, height: rightView.frame.height)
            }
            
        }
        private func applyFontAttributes(to textField: UITextField, fontSize: CGFloat, kernValue: CGFloat) {
            guard let currentText = textField.text else { return }
            
            let font = UIFont.pretendardFont(.bold, size: fontSize)
            let attributedString = NSMutableAttributedString(string: currentText)
            
            attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length))
            
            textField.attributedText = attributedString
        }
    }
}

class MoneyFixedSizeTextField: UITextField {
    let scaler = Scaler.shared
    override var intrinsicContentSize: CGSize {
        return CGSize(width: scaler.scaleWidth(312), height: scaler.scaleHeight(38))
    }
}
