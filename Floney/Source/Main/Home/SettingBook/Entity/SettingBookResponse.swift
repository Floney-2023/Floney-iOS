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
    var ourBookUsers : [BookUsers]
}
struct BookUsers: Decodable, Hashable {
    var name : String
    var profileImg : String?
    var role : String
    var me : Bool
}
