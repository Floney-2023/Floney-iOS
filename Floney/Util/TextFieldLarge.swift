//
//  TextFieldLarge.swift
//  Floney
//
//  Created by 남경민 on 2023/05/31.
//

import SwiftUI

struct TextFieldLarge: View {
    @Binding var label : String
    @Binding var content : String

    var body: some View {
        TextField("", text: $content)
            .multilineTextAlignment(.center)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .keyboardType(.numberPad)
            .modifier(TextFieldModifier())
            .overlay(
                Text(label)
                    .padding()
                    .font(.pretendardFont(.regular, size: 14))
                    .foregroundColor(.greyScale6)
                    .opacity(content.isEmpty ? 1 : 0), alignment: .center
            )
           
    }
}
