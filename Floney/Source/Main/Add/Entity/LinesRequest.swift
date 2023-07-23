//
//  LinesRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation
struct LinesRequest : Encodable {
    var bookKey: String
    var money: Float
    var lineDate: String
    var flow: String
    var asset: String
    var line: String
    var description: String
    var except: Bool
    var nickname: String
}
