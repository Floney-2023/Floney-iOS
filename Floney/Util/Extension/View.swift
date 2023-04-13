//
//  View.swift
//  Floney
//
//  Created by 남경민 on 2023/04/08.
//

import SwiftUI

extension View {
    // MARK: call next button modifier 
    func withNextButtonFormmating(_ backgroundColor: Color = .blue) -> some View {
        // RETURN BODY
        modifier(NextButtonModifier(backgroundColor: backgroundColor))
    }
    
    // MARK: corner radius
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
            clipShape( RoundedCorners(radius: radius, corners: corners) )
    }
}
