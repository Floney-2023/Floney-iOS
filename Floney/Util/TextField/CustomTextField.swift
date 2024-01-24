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
        let textField = FixedSizeTextField(width: self.width)
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
        if isSecure {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "icon_closed_eye"), for: .normal)
            button.imageView?.frame = CGRect(x: 0, y: 0, width: scaler.scaleWidth(24), height: scaler.scaleWidth(24))
            button.addTarget(context.coordinator, action: #selector(Coordinator.togglePasswordVisibility(_:)), for: .touchUpInside)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            textField.rightView = button
            textField.rightViewMode = .always
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
        if let fixedSizeTextField = uiView as? FixedSizeTextField {
            fixedSizeTextField.addWonLabelIfNeeded(isCenterAligned: alignment == .center, textIsEmpty: text.isEmpty)
        }
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
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        @objc func togglePasswordVisibility(_ sender: UIButton) {
            guard let textField = sender.superview as? UITextField else { return }
            textField.isSecureTextEntry.toggle()
            let imageName = textField.isSecureTextEntry ? "icon_closed_eye" : "icon_open_eye"
            sender.setImage(UIImage(named: imageName), for: .normal)
        
        }
    }
}

class FixedSizeTextField: UITextField {
    let scaler = Scaler.shared
    var fixedWidth: CGFloat
    var textFont: UIFont {
        .pretendardFont(.regular, size: scaler.scaleWidth(14))
    }
    var color: UIColor = .greyScale2
    
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
    func addWonLabelIfNeeded(isCenterAligned: Bool, textIsEmpty: Bool) {
        if isCenterAligned && !textIsEmpty {
            let padding: CGFloat = 20 // 원하는 만큼의 패딩 값을 설정하세요.
            let labelWidth: CGFloat = 40 // "원" 레이블의 너비를 설정하세요.
            
            // "원" 레이블을 위한 컨테이너 뷰
            let wonLabelContainer = UIView(frame: CGRect(x: 0, y: 0, width: labelWidth + padding, height: 49.666666666666664))
            let wonLabel = UILabel()
            wonLabel.text = CurrencyManager.shared.currentCurrency
            wonLabel.font = textFont
            wonLabel.textColor = color
            wonLabel.frame = CGRect(x: padding, y: 0, width: labelWidth, height: 49.666666666666664)
            wonLabelContainer.addSubview(wonLabel)
            
            rightView = wonLabelContainer
            rightViewMode = .always
            
            // 텍스트가 중앙에 위치하도록 왼쪽에도 동일한 크기의 뷰 추가
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: labelWidth + padding, height: 49.666666666666664))
            leftView = leftPaddingView
            leftViewMode = .always
            
            // 레이아웃 업데이트 강제 실행
            self.layoutIfNeeded()
        } else {
            if isCenterAligned {
                rightView = nil
                rightViewMode = .never
                leftView = nil
                leftViewMode = .never
            }
        }
    }
    
}
