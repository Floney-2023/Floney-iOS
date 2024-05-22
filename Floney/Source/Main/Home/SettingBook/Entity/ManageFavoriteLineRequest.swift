//
//  ManageFavoriteLineRequest.swift
//  Floney
//
//  Created by 남경민 on 5/21/24.
//

import Foundation

struct FavoriteLineRequest: Encodable {
    let bookKey: String
    let categoryType: String
}
struct AddFavoriteLineRequest : Encodable {
    var money: Double
    var description: String
    var lineCategoryName: String
    var lineSubcategoryName: String
    var assetSubcategoryName: String
}

struct DeleteFavoriteLineRequest: Encodable {
    let bookKey: String
    let favoriteId: Int
}
