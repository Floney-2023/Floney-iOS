//
//  CategoryRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation

struct CategoryRequest: Encodable {
    var bookKey: String
    var root: String
}

struct AddCategoryRequest: Encodable {
    var bookKey: String
    var parent : String
    var name : String
}

struct DeleteCategoryRequest : Encodable {
    var bookKey : String
    var root : String
    var name : String
}
