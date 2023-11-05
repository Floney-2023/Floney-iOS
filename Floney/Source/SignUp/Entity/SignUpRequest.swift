//
//  SignUpRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//
import Foundation

struct SignUpRequest: Encodable {
    var email: String
    var password: String
    var nickname: String
    var receiveMarketing : Bool
}
struct SNSSignUpRequest : Encodable {
    var email : String
    var nickname: String
    var receiveMarketing : Bool
}

struct AuthEmailRequest: Encodable {
    var email: String
}

struct CheckCodeRequest : Encodable {
    var email : String
    var code : String
}
