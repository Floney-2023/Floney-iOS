//
//  BookExistenceResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/07/17.
//

import Foundation

struct BookExistenceResponse : Decodable {
    var bookKey : String?
    var bookStatus : String?
}
