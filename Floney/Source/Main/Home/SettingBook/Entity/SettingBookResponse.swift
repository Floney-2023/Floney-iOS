//
//  SettingBookResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation

struct BookInfoResponse: Decodable {
    var bookImg : String?
    var bookName : String
    var startDay : String
    var seeProfileStatus : Bool
    var carryOver : Bool
    var ourBookUsers : [BookUsers]
}
struct BookUsers: Decodable, Hashable {
    var name : String
    var profileImg : String?
    var role : String
    var me : Bool
}

struct ShareCodeResponse: Decodable {
    var code : String
}
struct SetCurrencyResponse : Decodable {
    var myBookCurrency : String
}

