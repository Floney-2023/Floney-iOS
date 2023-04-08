//
//  View.swift
//  Floney
//
//  Created by 남경민 on 2023/04/08.
//

import SwiftUI

extension View {
    func withNextButtonFormmating(_ backgroundColor: Color = .blue) -> some View {
        // RETURN BODY
        modifier(NextButtonModifier(backgroundColor: backgroundColor))
    }
}
