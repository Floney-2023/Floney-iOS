//
//  CalendarResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation

struct CalendarResponse: Decodable {
    var totalIncome: Int
    var totalOutcome: Int
    var result: [CalendarExpenses]?
}

struct CalendarExpenses: Decodable {
    var date: String
    var money: Int
    var assetType: String
}
