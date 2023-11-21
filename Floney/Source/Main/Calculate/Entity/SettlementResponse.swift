//
//  SettlementResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/07/10.
//

import Foundation

struct SettlementResponse : Decodable, Hashable {
    var money : Double
    var category : [String]
    var assetType : String
    var content : String
    var userEmail : String
    var img : String?
    var isSelected : Bool?
}

struct AddSettlementResponse : Decodable, Hashable {
    var id : Int
    var userCount : Int
    var startDate : String
    var endDate : String
    var totalOutcome : Double
    var outcome : Double
    var details : [AddSettlementResponseDetails]
}

struct AddSettlementResponseDetails : Decodable, Hashable {
    var money : Double
    var userNickname : String
    var userProfileImg : String
}

struct SettlementListResponse : Decodable, Hashable {
    var id : Int
    var userCount : Int
    var startDate : String
    var endDate : String
    var totalOutcome : Double
    var outcome : Double
}

struct BookUsersResponse : Decodable, Hashable {
    var nickname : String
    var email : String
    //var subscribe : Bool
    //var lastAdTime : String
    //var provider : String
    var profileImg : String
    //var status : String
    var isSelected : Bool?
}
struct PassedDays : Decodable {
    var passedDays : Int
}
