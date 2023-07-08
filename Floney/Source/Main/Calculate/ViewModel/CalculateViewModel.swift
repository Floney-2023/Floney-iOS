//
//  CalculateViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import Foundation

class CalculateViewModel : ObservableObject {
    @Published var startDate : Date = Date()
    @Published var endDate : Date = Date()
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
}
