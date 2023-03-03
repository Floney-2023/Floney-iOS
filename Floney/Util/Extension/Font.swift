//
//  Font.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import SwiftUI

extension Font {
    enum PretendardFont {
        case regular
        case extraLight
        case light
        case medium
        case semiBold
        case bold
        case black
        case extraBold
        case thin
        case custom(String)
        
        var value: String {
            switch self {
            case .regular:
                return "Regular"
            case .extraLight:
                return "ExtraLight"
            case .light:
                return "Light"
            case .medium:
                return "Medium"
            case .semiBold:
                return "SemiBold"
            case .bold:
                return "Bold"
            case .black:
                return "Black"
            case .extraBold:
                return "ExtraBold"
            case .thin:
                return "Thin"
            case .custom(let name):
                return name
            }
        }
    }
    static func pretendardFont(_ type: PretendardFont, size: CGFloat = 17) -> Font {
        return .custom("Pretendard-\(type.value)", size: size)
    }
}

