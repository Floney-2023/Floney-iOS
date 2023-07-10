//
//  AnalysisViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import Foundation
import Combine
import SwiftUI

class AnalysisViewModel : ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var loadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var selectedColors : [Color] = []
    @Published var incomeSelectedColors : [Color] = []
    let expenses : [ExpenseResponse] = [
    ExpenseResponse(content: "식비", percentage: 40, money: 400000),
    ExpenseResponse(content: "생활비", percentage: 40, money: 400000),
    ExpenseResponse(content: "기타", percentage: 20, money: 200000)
    ]
    let incomes : [ExpenseResponse] = [
    ExpenseResponse(content: "식비", percentage: 40, money: 400000),
    ExpenseResponse(content: "생활비", percentage: 40, money: 400000),
    ExpenseResponse(content: "기타", percentage: 20, money: 200000)
    ]
    let primaryColors: [Color] = [
        .yellow2, .orange3, .red2
    ]
    let incomeColors: [Color] = [
        .blue3, .indigo1, .purple2
    ]
    let randomColors : [Color] = [
        .red1, .red3,
        .orange2, .orange4,
        .yellow1, .yellow3,
        .blue1, .blue3, .blue4,
        .indigo1, .indigo2, .indigo3,
        .purple1, .purple2, .purple3
    ]
    let incomeRandomColors : [Color] = [
        .yellow2, .orange3, .red2,
        .red1, .red3,
        .orange2, .orange4,
        .yellow1, .yellow3,
        .blue1, .blue4,
        .indigo2, .indigo3,
        .purple2, .purple3
    ]
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: AnalysisProtocol
    
    
    init( dataManager: AnalysisProtocol = AnalysisService.shared) {
        self.dataManager = dataManager
        self.selectColor()
        self.selectColor2()
    }
    func selectColor() {
        for i in 0..<expenses.count {
            getColor(index: i)
        }
    }
    func selectColor2() {
        for i in 0..<incomes.count {
            getColor2(index: i)
        }
    }
    func getColor(index: Int) {
        if index < primaryColors.count {
            selectedColors.append(primaryColors[index])
           
        } else {
            let randomIndex = Int.random(in: 0..<randomColors.count)
            selectedColors.append(randomColors[randomIndex])
           
        }
    }
    func getColor2(index: Int) {
        if index < primaryColors.count {
            incomeSelectedColors.append(incomeColors[index])
           
        } else {
            let randomIndex = Int.random(in: 0..<randomColors.count)
            incomeSelectedColors.append(incomeRandomColors[randomIndex])
        }
    }
    
    
    func createAlert( with error: NetworkError) {
        loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        // 에러 처리
        
        if let errorCode = error.backendError?.code {
            switch errorCode {
                //case "U009" :
                //print("\(errorCode) : alert")
                //self.showAlert = true
                //self.errorMessage = ErrorMessage.login01.value
                // 토큰 재발급
            case "U006" :
                tokenViewModel.tokenReissue()
                // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
            case "U007" :
                AuthenticationService.shared.logoutDueToTokenExpiration()
            default:
                break
            }
            // 에러 처리
        }
    }
}
