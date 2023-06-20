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
    var dayLinesResponse : [DayLinesResults]
    var totalExpense : [DayTotalExpenses]
}

struct DayLinesResults: Decodable, Hashable {
    var money : Int
    var img : String
    var category : [String]
    var assetType : String
    var content : String
}

struct DayTotalExpenses: Decodable {
    var money : Int
    var assetType : String
}
/// 데이터를 추가 / 읽기 / 수정 / 삭제 (CRUD)
class DayLinesViewModel {
    var dayLineList: DayLinesResponse
    // count
    //var count: Int { self.dayLineList.count }
    
    init() {
        dayLineList =  DayLinesResponse(
            dayLinesResponse:
                [
                    DayLinesResults(money: 10000, img: "", category: ["식비"], assetType: "OUTCOME", content: "점심"),
                    DayLinesResults(money: 10000, img: "", category: ["식비"], assetType: "OUTCOME", content: "저녁"),
                    DayLinesResults(money: 10000, img: "", category: ["급여"], assetType: "INCOME", content: "급여"),
                    DayLinesResults(money: 10000, img: "", category: ["급여"], assetType: "INCOME", content: "알바")
                ],
            totalExpense:
                [
                    DayTotalExpenses(money: 20000, assetType: "INCOME"),
                    DayTotalExpenses(money: 20000, assetType: "OUTCOME")
                ]
        )
    }
}


