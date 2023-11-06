//
//  LineModel.swift
//  Floney
//
//  Created by 남경민 on 2023/08/25.
//

import Foundation

class LineModel : ObservableObject{
    @Published var mode : String = "add"
    @Published var lineId = 0
    @Published var toggleType = "지출" // 지출, 수입, 이체
    @Published var selectedOptions = 0
}
