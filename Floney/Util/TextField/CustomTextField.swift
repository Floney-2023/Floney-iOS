//
//  CustomTextField.swift
//  Floney
//
//  Created by 남경민 on 2023/09/13.
//

import Foundation
import UIKit
import SwiftUI
struct CustomTextField: UIViewRepresentable {
    let scaler = Scaler.shared
    @State var width : CGFloat = 320
    @Binding var text: String
    var placeholder: String
    
    var isSecure: Bool = false  // 추가: 비밀번호 입력 필드 여부
    var keyboardType: UIKeyboardType = .default
    var alignment: NSTextAlignment = .left  // 새로운 정렬 속성 추가
    
    var textFont: UIFont {
        .pretendardFont(.regular, size: scaler.scaleWidth(14))
    }
    var textColor: UIColor = .greyScale2
    
    var placeholderFont: UIFont {
        .pretendardFont(.regular, size: scaler.scaleWidth(14))
    }
    var placeholderColor: UIColor
    
    var backgroundColor: UIColor = .greyScale12
    var strokeColor: UIColor = .greyScale10
    var cornerRadius: CGFloat = 12
    
    var placeholderPadding: CGFloat {
        scaler.scaleWidth(20)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = FixedSizeTextField(width: self.width)//UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 사용 설정
        textField.delegate = context.coordinator
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: placeholderColor,
            NSAttributedString.Key.font: placeholderFont
        ]


        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        textField.font = textFont
        textField.textColor = textColor
        textField.isSecureTextEntry = isSecure  // 비밀번호 필드 설정
        // 키보드 타입 설정
        textField.keyboardType = keyboardType
        // 텍스트 정렬 설정
        textField.textAlignment = alignment  // 정렬 속성 적용
        // alignment가 center가 아닐 때만 leftView를 설정
       
        if alignment != .center {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: placeholderPadding, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.backgroundColor = backgroundColor
        
        // Add border and cornerRadius
        uiView.layer.borderColor = strokeColor.cgColor
        uiView.layer.borderWidth = 1.0
        uiView.layer.cornerRadius = cornerRadius

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        
        init(_ parent: CustomTextField) {
            self.parent = parent
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
    }
}

class FixedSizeTextField: UITextField {
    let scaler = Scaler.shared
    var fixedWidth: CGFloat

    // Designated initializer with a width parameter
    init(width: CGFloat) {
        self.fixedWidth = width
        super.init(frame: .zero) // Call to designated initializer of the superclass
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Common initializer code which can be extracted to avoid duplication
    private func commonInit() {
        // Additional common setup can be done here if needed
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: scaler.scaleWidth(fixedWidth), height: scaler.scaleHeight(46))
    }
}
