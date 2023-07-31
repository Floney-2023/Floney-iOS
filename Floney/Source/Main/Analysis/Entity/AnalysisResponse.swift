//
//  AnalysisResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import Foundation

struct ExpenseResponse: Decodable, Hashable {
    var content : String
    var percentage : Int
    var money : Float
}

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
}
