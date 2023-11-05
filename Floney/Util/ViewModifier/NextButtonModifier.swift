//
//  NextButtonModifier.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import Foundation
import SwiftUI

struct NextButtonModifier: ViewModifier {
    let scaler = Scaler.shared
    let backgroundColor : Color
    func body(content: Content) -> some View {
        
        content
            .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
            .foregroundColor(.white)
            .frame(width: scaler.scaleWidth(320), height: scaler.scaleHeight(46))
            .background(backgroundColor)
            .cornerRadius(12)

    }
}
