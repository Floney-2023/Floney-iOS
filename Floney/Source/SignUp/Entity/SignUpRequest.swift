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
    var marketingAgree : Int
}
