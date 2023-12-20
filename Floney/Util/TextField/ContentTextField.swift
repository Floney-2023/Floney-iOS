//
//  ContentTextField.swift
//  Floney
//
//  Created by 남경민 on 2023/09/14.
//

import Foundation
import UIKit
import SwiftUI
struct ContentTextField: UIViewRepresentable {
    let scaler = Scaler.shared
    @Binding var text: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var alignment: NSTextAlignment = .right  // 새로운 정렬 속성 추가
    /*
    var textFont: UIFont {
        .pretendardFont(.medium, size:scaler.scaleWidth(14))
    }*/
    var textFont: UIFont {
        createDynamicTypeFont(name: "Pretendard-Medium", baseSize: 14)
    }
    
    var placeholderFont: UIFont {
        createDynamicTypeFont(name: "Pretendard-Medium", baseSize: 14)
    }
    var textColor: UIColor = .greyScale2
    /*
    var placeholderFont: UIFont {
        .pretendardFont(.medium, size:scaler.scaleWidth(14))
    }*/
    var placeholderColor: UIColor = .greyScale6
    
    var backgroundColor: UIColor = .clear
    // 커스텀 폰트와 UIFontMetrics를 사용하여 Dynamic Type을 지원하는 폰트 생성
    private func createDynamicTypeFont(name: String, baseSize: CGFloat) -> UIFont {
        let scaledSize = scaler.scaleWidth(baseSize)
        guard let font = UIFont(name: name, size: scaledSize) else {
            fatalError("Failed to load the \(name) font.")
        }
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
    }
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 사용 설정
        textField.delegate = context.coordinator
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
      
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.backgroundColor = backgroundColor
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: ContentTextField
        
        init(_ parent: ContentTextField) {
            self.parent = parent
        }
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}



