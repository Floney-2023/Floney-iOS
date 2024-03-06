//
//  ManageRepeatLineRequest.swift
//  Floney
//
//  Created by 남경민 on 3/6/24.
//

import Foundation

struct RepeatLineRequest: Encodable {
    let bookKey: String
    let categoryType: String
}
struct DeleteRepeatLineRequest: Encodable {
    let repeatLineId: Int
}
struct DeleteAllRepeatLineRequest: Encodable {
    let bookLineKey: Int
}
