//
//  TextFieldModifier.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import Foundation
import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pretendardFont(.regular, size: 14))
            .foregroundColor(.greyScale2)
            .background(Color.greyScale12)
            .cornerRadius(12)
        //.border(Color.greyScale10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.greyScale10, lineWidth: 1) // Set the border
            )
    }
}
