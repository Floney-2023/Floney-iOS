//
//  SettingBookRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation

struct BookInfoRequest : Encodable {
    var bookKey : String
}
struct BookNameRequest : Encodable {
    var name : String
    var bookKey : String
}
struct BookProfileRequest : Encodable {
    var newUrl : String?
    var bookKey : String
}

struct SeeProfileRequest : Encodable {
    var bookKey : String
    var seeProfileStatus : Bool
}
struct SetBudgetRequest : Encodable {
    var bookKey : String
    var budget : Double
    var date : String
}
struct SetAssetRequest : Encodable {
    var bookKey : String
    var asset : Double
}
struct SetCarryOver : Encodable {
    var bookKey : String
    var status : Bool
}

struct SetCurrencyRequest : Encodable {
    var requestCurrency : String
    var bookKey : String
}
