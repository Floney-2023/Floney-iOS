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
    
    //MARK: 지출, 수입 분석
    @Published var expenseResponse = ExpenseIncomeResponse(total: 0, differance: 0, analyzeResult: [])
    @Published var incomeResponse = ExpenseIncomeResponse(total: 0, differance: 0, analyzeResult: [])
    @Published var expensePercentage : [Double] = []
    @Published var incomePercentage : [Double] = []
    
    //MARK: 예산 분석
    @Published var leftBudget : Double = 0
    @Published var totalBudget : Double = 0
    @Published var budgetPercentage : Double = 0
    @Published var budgetRatio : Double = 0
    @Published var dailyAvailableMoney : Double = 0
    
    //MARK: 자산 분석
    @Published var monthList : [String] = []
    @Published var assetList : [Asset] = []
    @Published var difference : Double = 0
    @Published var currentAsset : Double = 0
    @Published var initAsset : Double = 0
    
    
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
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = ExpenseIncomeRequest(bookKey: bookKey, root: root, date: selectedDateStr)
        print(request)
        
        LoadingManager.shared.update(showLoading: true, loadingType: .progressLoading)
        dataManager.analysisExpenseIncome(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.analysisExpenseIncome(root: root)
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                } else {
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
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
        
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BudgetAssetRequest(bookKey: bookKey, date: selectedDateStr)
        
        
        LoadingManager.shared.update(showLoading: true, loadingType: .progressLoading)
        dataManager.analysisBudget(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.analysisBudget()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                } else {
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                    self.leftBudget = dataResponse.value?.leftMoney ?? 0
                    self.totalBudget = dataResponse.value?.initBudget ?? 0
                    if self.totalBudget > 0 && self.leftBudget > 0 {
                        self.budgetRatio = (self.totalBudget - self.leftBudget) / self.totalBudget
                        self.budgetPercentage = self.budgetRatio * 100
                    } else if self.leftBudget == 0 {
                        self.budgetPercentage = 0
                        self.budgetRatio = 0
                    } else {
                        self.budgetPercentage = 100
                        self.budgetRatio = 1
                    }
                    
                    if self.leftBudget > 0 {
                        self.calcDailyAvailableMoney()
                    } else {
                        self.dailyAvailableMoney = 0
                    }
                    print("left budget : \(self.leftBudget)")
                    print("total budget : \(self.totalBudget)")
                    print("budget percentage : \(self.budgetPercentage)")
                    print("budget ratio : \(self.budgetRatio)")
                    
                }
            }.store(in: &cancellableSet)
    }
    func calcDailyAvailableMoney() {
        let calendar = Calendar.current
        let today = Date()
        
        // 오늘의 날짜 구하기
        let dayOfMonth = calendar.component(.day, from: today)
        
        // 현재 달의 마지막 날짜 구하기
        let range = calendar.range(of: .day, in: .month, for: today)
        let lastDayOfMonth = range?.count ?? 30  // 기본값으로 30일을 사용합니다.
        
        // 남은 날짜 계산
        let remainingDays = lastDayOfMonth - dayOfMonth + 1
        
        // 하루에 사용할 수 있는 금액 계산
        let dailyAvailableMoney = self.leftBudget / Double(remainingDays)
        
        print("하루에 사용할 수 있는 금액은 \(dailyAvailableMoney) 입니다.")
        self.dailyAvailableMoney = dailyAvailableMoney
    }
    
    func analysisAsset(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //var assetMonth = 0
        //var assetYear = 0
        //let date = dateFormatter.date(from: date) //{
            //let calendar = Calendar.current
           // let components = calendar.dateComponents([.year,.month], from: date)
           // if let month = components.month {
           //     print(month) // 출력: 2
           //     assetMonth = month
           // }
           // if let year = components.year {
           //     assetYear = year
           // }
        //}
        var date = ""

        let dateString = dateFormatter.string(from: selectedDate)
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        if let year = components.year, let month = components.month {
            date = "\(year)-\(String(format: "%02d", month))-01"
        }
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BudgetAssetRequest(bookKey: bookKey, date: date)
        
        LoadingManager.shared.update(showLoading: true, loadingType: .progressLoading)
        dataManager.analysisAsset(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.analysisAsset(date: date)
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                } else {
                    LoadingManager.shared.update(showLoading: false, loadingType: .progressLoading)
                    var asset = dataResponse.value ?? AssetResponse(difference: 0, initAsset: 0, currentAsset: 0, assetInfo: [:])
                    //asset.month = assetMonth  // 해당 월을 AssetResponse에 저장합니다.
                    //asset.year = assetYear
                    //if date == self.selectedDateStr {
                    let assetInfoDictionary = asset.assetInfo  // 예: [String: AssetInfo] 타입의 딕셔너리

                    self.assetList = assetInfoDictionary.compactMap { key, value in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"

                        guard let date = dateFormatter.date(from: key) else { return nil }
                        let monthFormatter = DateFormatter()
                        monthFormatter.dateFormat = "yyyy-MM"

                        let monthString = monthFormatter.string(from: date)
                        return Asset(assetMoney: value.assetMoney,month: monthString)
                    }
                    // assetList 정렬
                    self.assetList.sort { first, second in
                        let firstComponents = first.month.split(separator: "-").map { Int($0) }
                        let secondComponents = second.month.split(separator: "-").map { Int($0) }

                        if let firstYear = firstComponents.first, let firstMonth = firstComponents.last,
                           let secondYear = secondComponents.first, let secondMonth = secondComponents.last {
                            if firstYear != secondYear {
                                return firstYear! < secondYear!
                            } else {
                                return firstMonth! < secondMonth!
                            }
                        }

                        return false
                    }

                    // 월만 추출하여 다시 할당
                    self.assetList = self.assetList.map { assetMonthInfo in
                        var modifiedInfo = assetMonthInfo
                        let monthComponents = assetMonthInfo.month.split(separator: "-")
                        if monthComponents.count == 2 {
                            modifiedInfo.month = String(monthComponents[1])
                        }
                        return modifiedInfo
                    }

                    print(self.assetList)
                    self.difference = dataResponse.value?.difference ?? 0
                    self.currentAsset = dataResponse.value?.currentAsset ?? 0
                    self.initAsset = dataResponse.value?.initAsset ?? 0
                   // }
                }
            }.store(in: &cancellableSet)
    }
    
    func initAssetList() {
        self.assetList = []
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
    
    /*
    // asset의 달을 계산하는 함수
    func calculateAssetMonth() {
        DispatchQueue.main.async {
            self.assetList = []
            var dates : [String] = []
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            for i in 0..<6 {
                if let newDate = Calendar.current.date(byAdding: .month, value: -i, to: self.selectedDate) {
                    let dateString = formatter.string(from: newDate)
                    let components = Calendar.current.dateComponents([.year, .month], from: newDate)
                    if let year = components.year, let month = components.month {
                        dates.append("\(year)-\(String(format: "%02d", month))-01")
                    }
                }
            }
            self.monthList = dates
            for date in self.monthList {
                self.analysisAsset(date: date)
            }
        }
    }*/
    
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            if error.backendError?.code != "U006" {
                AlertManager.shared.handleError(serverError)
            }
            // 에러코드에 따른 추가 로직
            if let errorCode = error.backendError?.code {
                switch errorCode {
                    // 토큰 재발급
                case "U006" :
                    tokenViewModel.tokenReissue {
                        // 토큰 재발급 성공 시, 원래의 요청 재시도
                        retryRequest()
                    }
                // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
                case "U007" :
                    AuthenticationService.shared.logoutDueToTokenExpiration()
                default:
                    break
                }
            }
        } else {
            // BackendError 없이 NetworkError만 발생한 경우
            //showAlert(message: "네트워크 오류가 발생했습니다.")
        }
    }
}
