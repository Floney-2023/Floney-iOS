//
//  SettlementRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/07/10.
//

import Foundation

struct SettlementRequest : Encodable {
    var usersEmails : [String]
    var dates : SettlementDate
    
}
struct SettlementDate : Encodable {
    var startDate : String
    var endDate : String
}

struct AddSettlementRequest : Encodable {
    var bookKey : String
    var userEmails : [String]
    var startDate : String
    var endDate : String
    var outcomes : [OutComes]

}
struct OutComes : Encodable {
    var outcome : Float
    var userEmail : String
}
