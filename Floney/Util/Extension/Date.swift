//
//  Date.swift
//  Floney
//
//  Created by 남경민 on 2023/07/13.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    static func from(year: Int, month: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        return calendar.date(from: components) ?? Date()
    }
}
