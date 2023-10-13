//
//  NotiResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/10/03.
//

import Foundation

struct NotiResponse : Decodable, Identifiable{
    var id : Int
    var title : String
    var body : String
    var imgUrl : String
    var date : String
    var received : Bool
}

struct BookNoti : Identifiable {
    let id : UUID = UUID()
    var bookKey : String
    var bookName : String
    var notiList : [NotiResponse]
}
