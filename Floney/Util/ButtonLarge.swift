//
//  ButtonLarge.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//


import SwiftUI

struct ButtonLarge: View {
    
    var label: String
    var background: Color = .white
    var textColor: Color
    var strokeColor : Color
    var fontWeight : Font.PretendardFont = .regular
    var action: (() -> ())
    
    let cornorRadius: CGFloat = 12
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(label)
                    .foregroundColor(textColor)
                    .font(.pretendardFont(fontWeight, size: 14))
                    .lineLimit(1)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: cornorRadius)
                    .stroke(strokeColor, lineWidth: 1)
            )
        }
        .background(background)
        .cornerRadius(cornorRadius)
    }
}

