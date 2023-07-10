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
