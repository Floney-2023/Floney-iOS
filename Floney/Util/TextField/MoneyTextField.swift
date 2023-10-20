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
        let textField = UITextField()
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
        func textFieldDidChangeSelection(_ textField: UITextField) {
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
    }
}
