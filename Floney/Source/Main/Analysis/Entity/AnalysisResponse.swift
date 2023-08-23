//
//  AnalysisResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import Foundation

struct AssetData : Decodable, Hashable{
    let month: String
    let amount: Double
}

struct ExpenseIncomeResponse: Decodable, Hashable {
    var total : Double
    var differance : Double
    var analyzeResult : [ExpenseIncome]
}

struct ExpenseIncome : Decodable, Hashable {
    var category : String
    var money : Double
    var percentage : Double?
}

struct BudgetResponse: Decodable {
    var leftMoney : Double
    var initBudget : Double
}
struct AssetResponse: Decodable {
    var difference : Double
    var initAsset : Double
    var currentAsset : Double
    var month : Int?
}

