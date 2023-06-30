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
    var newUrl : String
    var bookKey : String
}

