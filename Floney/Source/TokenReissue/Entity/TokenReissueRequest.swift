//
//  TokenReissueRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/05/17.
//

import Foundation

struct TokenReissueRequest: Encodable {
    var accessToken: String
    var refreshToken: String
}
