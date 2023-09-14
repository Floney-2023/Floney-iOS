//
//  CreateBookRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
struct CreateBookRequest: Encodable {
    var name: String
    var profileImg : String?
}
struct InviteBookRequest : Encodable {
    var code : String
}
