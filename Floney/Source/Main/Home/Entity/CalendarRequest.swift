//
//  CalendarRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation

struct CalendarRequest: Encodable {
    var bookKey: String
    var date: String
}

struct DayLinesRequest: Encodable {
    var bookKey : String
    var date : String
}
