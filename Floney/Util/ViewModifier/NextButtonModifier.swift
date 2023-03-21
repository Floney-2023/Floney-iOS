//
//  NextButtonModifier.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import Foundation
import SwiftUI

struct NextButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pretendardFont(.bold, size: 14))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.primary1)
            .cornerRadius(12)
    }
}
