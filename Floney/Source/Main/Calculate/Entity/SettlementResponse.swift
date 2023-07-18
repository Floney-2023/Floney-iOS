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

struct AddSettlementResponse : Decodable, Hashable {
    var id : Int
    var userCount : Int
    var startDate : String
    var endDate : String
    var totalOutcome : Float
    var outcome : Float
    var details : [AddSettlementResponseDetails]

}
struct AddSettlementResponseDetails : Decodable, Hashable {
    var money : Float
    var userNickname : String
}

struct SettlementListResponse : Decodable, Hashable {
    var id : Int
    var userCount : Int
    var startDate : String
    var endDate : String
    var totalOutcome : Float
    var outcome : Float
}

struct BookUsersResponse : Decodable, Hashable {
    var nickname : String
    var email : String
    var subscribe : Bool
    var lastAdTime : String
    var provider : String
    var status : String
}
