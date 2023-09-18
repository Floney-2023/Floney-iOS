//
//  UINavigationController.swift
//  Floney
//
//  Created by 남경민 on 2023/09/17.
//

import Foundation
import UIKit
import SwiftUI
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
