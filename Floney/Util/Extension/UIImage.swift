//
//  UIImage.swift
//  Floney
//
//  Created by 남경민 on 2023/09/11.
//

import Foundation
import UIKit

extension UIImage {
    func copied() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
