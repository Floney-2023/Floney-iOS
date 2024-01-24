//
//  MyPageRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
struct MyPageRequest: Encodable {
    var name: String
    var profileImg : String
}

struct SignOutRequest : Encodable {
    var type : String
    var reason : String?
}
struct ChangePasswordRequest:Encodable {
    var newPassword:String
    var oldPassword: String
}
struct CheckPasswordRequest : Encodable {
    var password: String
}
