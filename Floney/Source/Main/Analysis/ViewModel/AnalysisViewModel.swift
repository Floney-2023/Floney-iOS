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
    @Published var isLoading: Bool = false
    @Published var loadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var selectedColors : [Color] = []
    @Published var incomeSelectedColors : [Color] = []
    
    @Published var selectedDate = Date()
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var selectedDateStr = ""
    // 피커 뷰에서 선택된 연도, 월
    @Published var yearMonth = YearMonthDuration(year: Date().year, month: Date().month) {
        didSet {
            selectedDate = Date.from(year: yearMonth.year, month: yearMonth.month)
            print("in Year Month 프로퍼티 selectedDate: \(selectedDate)")
        }
    }
    
    @Published var expenseResponse = ExpenseIncomeResponse(total: 0, differance: 0, analyzeResult: [])
    @Published var incomeResponse = ExpenseIncomeResponse(total: 0, differance: 0, analyzeResult: [])
    @Published var expensePercentage : [Double] = []
    @Published var incomePercentage : [Double] = []
    
    @Published var leftBudget : Double = 0
    @Published var totalBudget : Double = 0
    @Published var budgetPercentage : Double = 0
    @Published var budgetRatio : Double = 0
        
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
    private var cancellable: AnyCancellable?
    var dataManager: AnalysisProtocol
    
    
    init( dataManager: AnalysisProtocol = AnalysisService.shared) {
        self.dataManager = dataManager
        self.selectColor()
        self.selectColor2()
        updateDateString(selectedDate)
        cancellable = $selectedDate
            .sink { [weak self] in self?.updateDateString($0) }
    }
    func selectColor() {
        for i in 0..<expensePercentage.count {
            getColor(index: i)
        }
    }
    func selectColor2() {
        for i in 0..<incomePercentage.count {
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
    func analysisExpenseIncome(root: String) {
        let bookKey = "C9C30C52"
        //let bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = ExpenseIncomeRequest(bookKey: bookKey, root: root, date: selectedDateStr)
        print(request)
        self.isLoading = true
        dataManager.analysisExpenseIncome(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                    self.isLoading = false
                } else {
                    self.isLoading = false
                    if let expenseIncomeResponse = dataResponse.value {
                        print("---분석 요청 성공---")
                        
                        // 원본 데이터를 복사하면서 percentage를 계산하여 새로운 배열 생성
                        let updatedAnalyzeResult = expenseIncomeResponse.analyzeResult.map { expenseIncome -> ExpenseIncome in
                            var updatedExpenseIncome = expenseIncome
                            updatedExpenseIncome.percentage = expenseIncomeResponse.total == 0 ? 0 : (expenseIncome.money / expenseIncomeResponse.total) * 100
                            return updatedExpenseIncome
                        }
                        
                        // 새로운 ExpenseIncomeResponse 생성
                        let updatedResponse = ExpenseIncomeResponse(total: expenseIncomeResponse.total, differance: expenseIncomeResponse.differance, analyzeResult: updatedAnalyzeResult)
                        
                        if root == "지출" {
                            self.expenseResponse = updatedResponse
                            self.expensePercentage = updatedResponse.analyzeResult.compactMap { $0.percentage }
                            self.selectColor()
                            print("지출 분석 : \(self.expenseResponse)")
                        } else {
                            self.incomeResponse = updatedResponse
                            self.incomePercentage = updatedResponse.analyzeResult.compactMap { $0.percentage }
                            self.selectColor2()
                            print("수입 분석 : \(self.incomeResponse)")
                        }
                        
                    }
                    
                   
                }
            }.store(in: &cancellableSet)
    }
    func analysisBudget() {
        let bookKey = "C9C30C52"
        //let bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = BudgetRequest(bookKey: bookKey, date: selectedDateStr)
 
        self.isLoading = true
        dataManager.analysisBudget(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                    self.isLoading = false
                } else {
                    self.isLoading = false
                    self.leftBudget = dataResponse.value?.leftMoney ?? 0
                    self.totalBudget = dataResponse.value?.totalMoney ?? 0
                    if self.totalBudget > 0 {
                        self.budgetPercentage = self.leftBudget / self.totalBudget * 100
                        self.budgetRatio = self.leftBudget / self.totalBudget 
                    }
                }
            }.store(in: &cancellableSet)
    }

    private func updateDateString(_ date: Date) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-01"
        selectedDateStr = formatter.string(from: date)
       
        selectedMonth = calendar.component(.month, from: date)
    }
    // 이전 달로 이동하는 함수
    func moveBackward() {
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)
        selectedDate = newDate ?? selectedDate
    }
    
    // 다음 달로 이동하는 함수
    func moveForward() {
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)
        selectedDate = newDate ?? selectedDate
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
