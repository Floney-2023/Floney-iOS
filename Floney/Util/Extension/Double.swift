//
//  Double.swift
//  Floney
//
//  Created by 남경민 on 2023/09/17.
//

import Foundation

extension Double {
    var formattedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        // 소수점 없음
        let number = NSNumber(value: self)
        if floor(self) == self {
            if self > 99999999999 {
                return formatter.string(from: NSNumber(value: 99999999999))!//"99999999999"
            } else {
                return formatter.string(from: number)!//"\(Int(self))"
            }
        }
        // 소수점 둘째 자리까지 있음
        else if floor(self * 10) == self * 10 {
            if self > 999999999.99 {
                return formatter.string(from: NSNumber(value: 999999999.99))!//"999999999.99"
            } else {
                return formatter.string(from: number)!//String(format: "%.1f", self)
            }
        }
        // 소수점 셋째 자리 이상
        else {
            if CurrencyManager.shared.hasDecimalPoint {
                if self > 999999999.99 {
                    return formatter.string(from: NSNumber(value: 999999999.99))!//"999999999.99"
                } else {
                    return formatter.string(from: number)!//String(format: "%.2f", self)
                }
            } else {
                if self > 99999999999 {
                    return formatter.string(from: NSNumber(value: 99999999999))!//"99999999999"
                } else {
                    return formatter.string(from: number)!//"\(Int(self))"
                }
            }
        }
    }
}
