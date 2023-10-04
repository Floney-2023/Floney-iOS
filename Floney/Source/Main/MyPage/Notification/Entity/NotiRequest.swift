//
//  NotiRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/10/03.
//

import Foundation

struct NotiRequest : Encodable {
    var bookKey : String
    var title : String
    var body : String
    var imgUrl : String
    var userEmail : String
    var date : String
}
