//
//  String.swift
//  Floney
//
//  Created by 남경민 on 1/17/24.
//

import Foundation

extension String {
    func filenameFromContentDisposition() -> String? {
        let pattern = "filename=([^;\\n]*)"
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: self, range: NSRange(startIndex..., in: self)) {
            let filenameRange = match.range(at: 1)
            let filename = (self as NSString).substring(with: filenameRange)

            // URL 디코딩을 수행
            return filename.removingPercentEncoding
        }
        return nil
    }
}
