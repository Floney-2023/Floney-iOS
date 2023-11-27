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

    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}
