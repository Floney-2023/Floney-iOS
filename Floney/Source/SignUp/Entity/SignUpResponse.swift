//
//  SignUpResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import Foundation

struct SignUpResponse: Decodable {
    //var isSuccess: Bool
    //var code: Int
    //var message: String
    //var result: SignUpResult?
    var accessToken: String
    var refreshToken: String
}

struct SignUpResult: Decodable {
    var accessToken: String
    var refreshToken: String
}
/*
struct AuthEmailResponse: Decodable {
    var code : Int
}
*/
