//
//  ManageRepeatLineResponse.swift
//  Floney
//
//  Created by 남경민 on 3/6/24.
//

import Foundation

struct RepeatLineResponse: Decodable, Hashable {
    let id: Int
    let description: String
    let repeatDuration: String
    var repeatDurationDescription: String?
    let lineSubCategory: String
    let assetSubCategory: String
    let money: Double
}
