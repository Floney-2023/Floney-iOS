//
//  ManageFavoriteLineResponse.swift
//  Floney
//
//  Created by 남경민 on 5/21/24.
//

import Foundation

struct FavoriteLineResponse: Decodable, Hashable {
    let id: Int
    let description: String
    let lineCategoryName: String
    let lineSubcategoryName: String
    let assetSubcategoryName: String
    let money: Double
    let exceptStatus: Bool
}
