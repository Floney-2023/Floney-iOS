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
    let lineCagtegoryName: String
    let lineSubCategory: String
    let assetSubCategory: String
    let money: Double
}
