//
//  TokenReissueResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/05/17.
//

import Foundation

struct TokenReissueResponse: Decodable {
    var accessToken: String
    var refreshToken: String
}
