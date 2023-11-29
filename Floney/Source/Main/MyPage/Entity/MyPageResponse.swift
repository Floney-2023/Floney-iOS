//
//  MyPageResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//
import Foundation

struct MyPageResponse: Decodable {
    var nickname : String
    var email : String
    var profileImg : String
    var provider : String
    var lastAdTime : String? // null 일 수 있음
    var myBooks : [MyBookResult]?
}

struct MyBookResult : Decodable, Hashable {
    var bookImg : String?
    var bookKey : String
    var name : String
    var memberCount : Int
    //var bookStatus : String
}

struct SignoutResponse : Decodable {
    var deletedBookKeys : [String]
    var otherBookKeys : [String]
}
