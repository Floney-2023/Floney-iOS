//
//  CategoryButton.swift
//  Floney
//
//  Created by 남경민 on 2023/06/05.
//

import Foundation
import SwiftUI

struct CategoryButton: View {
    let label: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                //.frame(minWidth: 0, maxWidth: .infinity)
                .font(.pretendardFont(.medium, size: 14))
                .foregroundColor(isSelected ? .primary2 : .greyScale6)
                .padding()
                .background(isSelected ? Color.clear : Color.background2) // 배경색 변경
                .cornerRadius(49)
                .overlay(
                    RoundedRectangle(cornerRadius: 49)
                        .stroke(isSelected ? Color.primary2 : Color.clear)
                )
        }
        
        
    }
}
