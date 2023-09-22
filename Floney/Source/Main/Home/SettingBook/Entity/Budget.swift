//
//  Budget.swift
//  Floney
//
//  Created by 남경민 on 2023/09/15.
//

import Foundation

struct MonthlyAmount {
    let month: Int // 1 to 12
    let amount: Double
}

struct GetBudgetRequest : Encodable {
    var bookKey : String
    var date : String
}

struct GetBudgetResponse : Decodable {
    var JANUARY : Double
    var FEBRUARY : Double
    var MARCH : Double
    var APRIL : Double
    var MAY : Double
    var JUNE : Double
    var JULY : Double
    var AUGUST : Double
    var SEPTEMBER : Double
    var OCTOBER : Double
    var NOVEMBER : Double
    var DECEMBER : Double
}
