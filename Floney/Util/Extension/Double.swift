//
//  Double.swift
//  Floney
//
//  Created by 남경민 on 2023/09/17.
//

import Foundation

extension Double {
    var formattedString: String {
        // 소수점 없음
        if floor(self) == self {
            return "\(Int(self))"
        }
        // 소수점 둘째 자리까지 있음
        else if floor(self * 10) == self * 10 {
            return String(format: "%.1f", self)
        }
        // 소수점 셋째 자리 이상
        else {
            return String(format: "%.2f", self)
        }
    }
}