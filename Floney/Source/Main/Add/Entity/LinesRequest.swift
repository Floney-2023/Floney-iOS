//
//  LinesRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation
struct LinesRequest : Encodable {
    var bookKey: String
    var money: Double
    var lineDate: String
    var flow: String
    var asset: String
    var line: String
    var description: String
    var except: Bool
    var nickname: String
    var repeatDuration: String
}
struct DeleteLineRequest : Encodable {
    var bookLineKey : Int
}

struct ChangeLineRequest : Encodable {
    var lineId : Int
    var bookKey: String
    var money: Double
    var lineDate: String
    var flow: String
    var asset: String
    var line: String
    var description: String
    var except: Bool
    var nickname: String
}

enum RepeatDurationType: String {
    case none = "NONE"
    case everyday = "EVERYDAY"
    case week = "WEEK"
    case month = "MONTH"
    case weekday = "WEEKDAY"
    case weekend = "WEEKEND"
    
    func description() -> String {
        switch self {
        case .everyday: return "매일"
        case .week: return "매주"
        case .month: return "매달"
        case .weekday: return "주중"
        case .weekend: return "주말"
        case .none:
            return "없음"
        }
    }
}
