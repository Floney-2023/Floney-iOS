//
//  CalendarResponse.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation

//MARK: 캘린더 월별 조회
struct CalendarResponse: Decodable {
    var totalIncome: Double
    var totalOutcome: Double
    var expenses: [CalendarExpenses]
    var carryOverInfo : CarryOverInfo
}

struct CalendarExpenses: Decodable, Hashable {
    var date: String
    var money: Double
    var assetType: String
}

//MARK: 일별내역 조회 결과
struct DayLinesResponse: Decodable{
    var dayLinesResponse : [DayLinesResults?]
    var totalExpense : [DayTotalExpenses?]
    var carryOverInfo : CarryOverInfo
    var seeProfileImg : Bool
}

struct DayLinesResults: Decodable, Hashable {
    var id : Int
    var money : Double
    var img : String? // null일 수 있음
    var category : [String]
    var assetType : String
    var content : String
    var exceptStatus : Bool
    var userNickName : String
}

struct DayTotalExpenses: Decodable {
    var money : Double
    var assetType : String
}

struct CarryOverInfo : Decodable {
    var carryOverStatus : Bool
    var carryOverMoney : Double
}


