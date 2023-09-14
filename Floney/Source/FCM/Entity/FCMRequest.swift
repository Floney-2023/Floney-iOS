//
//  FCMRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/09/03.
//

import Foundation

struct FCMRequest :Encodable {
    var message : FCMMessage
}

struct FCMMessage :Encodable {
    var token : String
    var notification : FCMNotification
}
struct FCMNotification : Encodable {
    var title : String
    var body : String
}

struct FCMAccessToken : Decodable {
    var token :String
}
