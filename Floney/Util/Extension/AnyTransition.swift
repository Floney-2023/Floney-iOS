//
//  AnyTransition.swift
//  Floney
//
//  Created by 남경민 on 2023/08/30.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .bottom)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
