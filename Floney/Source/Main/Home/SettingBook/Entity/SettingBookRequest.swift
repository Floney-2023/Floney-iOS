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
    var budget : Float
}
struct SetAssetRequest : Encodable {
    var bookKey : String
    var asset : Float
}
struct SetCarryOver : Encodable {
    var bookKey : String
    var status : Bool
}
