//
//  SettlementResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/07/10.
//

import Foundation

struct SettlementResponse : Decodable, Hashable {
    var money : Float
    var category : [String]
    var assetType : String
    var content : String
    var img : String?
}
