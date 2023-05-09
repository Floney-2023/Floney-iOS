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
    var subscribe : Bool
    var lastAdTime : String? // null 일 수 있음
    var myBooks : [MyBookResult]?
}
struct MyBookResult : Decodable {
    var bookImg : String?
    var bookKey : String
    var name : String
    var memberCount : Int
}
