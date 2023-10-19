//
//  Scaler.swift
//  Floney
//
//  Created by 남경민 on 2023/10/19.
//

import Foundation
import SwiftUI

struct Scaler {
    let designWidth: CGFloat = 360
    let designHeight: CGFloat = 780

    let deviceWidth: CGFloat
    let deviceHeight: CGFloat

    let widthScale: CGFloat
    let heightScale: CGFloat

    init() {
        deviceWidth = UIScreen.main.bounds.size.width
        deviceHeight = UIScreen.main.bounds.size.height
        widthScale = deviceWidth / designWidth
        heightScale = deviceHeight / designHeight
    }

    func scaleWidth(_ value: CGFloat) -> CGFloat {
        return value * widthScale
    }

    func scaleHeight(_ value: CGFloat) -> CGFloat {
        return value * heightScale
    }
}
