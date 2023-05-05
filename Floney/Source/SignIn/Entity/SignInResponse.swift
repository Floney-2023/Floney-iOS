//
//  SignUpResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

struct SignInResponse: Decodable {
    //var isSuccess: Bool
    //var code: Int
    //var message: String
    //var result: SignInResult?
    var accessToken: String
    var refreshToken: String
}

struct SignInResult: Decodable {
    var accessToken: String
    var refreshToken: String
}
