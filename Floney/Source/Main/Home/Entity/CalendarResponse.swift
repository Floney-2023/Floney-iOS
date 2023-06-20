//
//  CalendarResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation

//MARK: 캘린더 월별 조회
struct CalendarResponse: Decodable {
    var totalIncome: Int
    var totalOutcome: Int
    var expenses: [CalendarExpenses]
}

struct CalendarExpenses: Decodable, Hashable {
    var date: String
    var money: Int
    var assetType: String
}

//MARK: 일별내역 조회 결과
struct DayLinesResponse: Decodable{
    var dayLinesResponse : [DayLinesResults?]
    var totalExpense : [DayTotalExpenses?]
    var seeProfileImg : Bool
}

struct DayLinesResults: Decodable, Hashable {
    var money : Int
    var img : String? // null일 수 있음
    var category : [String]
    var assetType : String
    var content : String
}

struct DayTotalExpenses: Decodable {
    var money : Int
    var assetType : String
}


