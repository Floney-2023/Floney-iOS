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
        
        CustomTextField(text: $content, placeholder: label, keyboardType: .decimalPad, alignment: .center, placeholderColor: .greyScale6)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}
