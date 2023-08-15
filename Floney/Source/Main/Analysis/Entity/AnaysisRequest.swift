//
//  AnaysisRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/07/31.
//

import Foundation

struct ExpenseIncomeRequest : Encodable {
    var bookKey : String
    var root : String
    var date : String
}

struct BudgetRequest: Encodable {
    var bookKey : String
    var date : String
}
