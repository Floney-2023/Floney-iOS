//
//  CreateBookResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation

struct CreateBookResponse: Decodable {
   // var name: String
    //var profileImg: String
   // var seeProfile : Int
    //var initialAsset : Int
    var bookKey : String
   // var budget : Int
   // var weekStartDay : String
   // var carryOver : Bool
    var code : String
    
}
struct BookInfoByCodeResponse: Decodable {
    var bookName : String
    var bookImg : String?
    var startDay : String
    var memberCount : Int
}
