//
//  AddViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation
import Combine
import Alamofire
class AddViewModel: ObservableObject {
    var fcmManager = FCMDataManager()
    var tokenViewModel = TokenReissueViewModel()
    var alertManager = AlertManager.shared
    @Published var isApiCalling = false
    @Published var successAdd = false
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var bookKey = ""
    
    //MARK: line
    @Published var lineResult : LinesResponse = LinesResponse(money: 0, flow: "", asset: "", line: "", lineDate: "", description: "", except: false, nickname: "")
    @Published var money = ""
    //@Published var lineDate = ""
    @Published var flow = ""
    @Published var asset = ""
    @Published var line = ""
    @Published var description = ""
    @Published var except = false
    @Published var nickname = ""
    @Published var repeatDuration : RepeatDurationType = RepeatDurationType.none
    @Published var selectedRepeat: String = "없음"
    @Published var selectedDurationIndex: Int = 0
    let durationOptions = ["없음", "매일", "매주", "매달", "주중", "주말"]
    let durationMapping: [String: RepeatDurationType] = [
        "없음": .none,
        "매일": .everyday,
        "매주": .week,
        "매달": .month,
        "주중": .weekday,
        "주말": .weekend
    ]
    let durationMappingText: [String: String] = [
        RepeatDurationType.none.rawValue: "없음",
        RepeatDurationType.everyday.rawValue: "매일",
        RepeatDurationType.week.rawValue: "매주",
        RepeatDurationType.month.rawValue: "매달",
        RepeatDurationType.weekday.rawValue: "주중",
        RepeatDurationType.weekend.rawValue: "주말"
    ]
    
    //MARK: category
    @Published var categoryResult : [CategoryResponse] = []
    @Published var categories : [String] = ["현금", "체크카드","신용카드","은행"]
    @Published var categoryStates : [Bool] = []
    @Published var root = ""
    let sortAssetOrder = ["현금", "체크카드", "신용카드", "은행"]
    let sortOutcomeOrder = ["식비", "카페/간식", "교통", "주거/통신", "의료/건강", "문화", "여행/숙박", "생활", "패션/미용", "육아", "교육", "경조사", "기타", "미분류"]
    let sortIncomeOrder =  ["급여", "부수입", "용돈", "금융소득", "사업소득", "상여금", "기타", "미분류"]
    let sortTransferOrder = ["이체","저축","현금", "투자", "보험", "카드대금", "대출", "기타", "미분류"]
        
    
    @Published var newCategoryName = "" {
        didSet {
            if newCategoryName.count > 6 {
                newCategoryName = String(newCategoryName.prefix(6))
            }
        }
    }

    @Published var deleteCategoryName = ""
    //MARK: delete line
    @Published var bookLineKey : Int = 0
    
    //MARK: calendar
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    // 메인으로 선택된 날짜 -> 이 날짜에 의해 좌우됨.
    @Published var selectedDate: Date = Date()
    @Published var selectedDateStr: String = ""
    @Published var presentedDate : Date = Date() {
        didSet {
            extractDate()
        }
    }
    @Published var presentedYearMonth : YearMonthDuration = YearMonthDuration(year: Date().year, month: Date().month) {
        didSet {
            presentedDate = Date.from(year: presentedYearMonth.year, month: presentedYearMonth.month)
        }
    }
    @Published var daysList : [[Date]] = [[]]
    @Published var successAddCategory = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: AddProtocol
    
    init( dataManager: AddProtocol = AddService.shared) {
        self.dataManager = dataManager
    }
    // 이차원 배열 달력
    func extractDate() {
        var days = daysInMonth()
        var result = [[Date]]()
        days.forEach {
            if result.isEmpty || result.last?.count == 7 {
                result.append([$0])
            } else {
                result[result.count - 1].append($0)
            }
        }
        self.daysList = result
    }
    func daysInMonth() -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: presentedDate)
        components.day = 1
        
        let firstDayOfMonth = calendar.date(from: components)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        if let startDay = calendar.date(byAdding: .day, value: -offsetDays, to: firstDayOfMonth),
           let rangeOfMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth) {
            for i in 0..<(rangeOfMonth.count + offsetDays) {
                if let date = calendar.date(byAdding: .day, value: i, to: startDay) {
                    dates.append(date)
                }
            }
        }
        while dates.count % 7 != 0 {
            if let date = calendar.date(byAdding: .day, value: 1, to: dates.last!) {
                dates.append(date)
            }
        }
        return dates
    }
    
    func convertStringToDate(_ dateString: String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        selectedDateStr = dateString
        selectedDate = dateFormatter.date(from: dateString) ?? Date()
        presentedDate = selectedDate
        
        print("selectedDate : \(selectedDate)")
        print("selectedDateStr : \(selectedDateStr)")
    }
    func convertDateToString(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        selectedDateStr = dateFormatter.string(from: date)
    }

    func isValidCategoryName() -> Bool {
        if newCategoryName.isEmpty {
            alertManager.handleError(InputValidationError.categoryNameEmpty)
            return false
        }
        return true
    }
    func isVaildAdd(money: String, asset: String, category: String) -> Bool {
        if money.isEmpty || money == "0" {
            alertManager.handleError(InputValidationError.moneyEmpty)
            return false
        }
        if asset == "자산을 선택하세요" {
            alertManager.handleError(InputValidationError.assetTypeEmpty)
            return false
        }
        if category == "분류를 선택하세요" {
            alertManager.handleError(InputValidationError.categoryTypeEmpty)
            return false
        }
        return true
    }
    
    //MARK: server
    func getCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = CategoryRequest(bookKey: bookKey, root: root)
        dataManager.getCategory(request)
            .sink {(dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getCategory()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.categoryResult = dataResponse.value!
                    print("--성공--")
                    print(self.categoryResult)
                    DispatchQueue.main.async {
                        var category: [String] = []
                        self.categoryStates = []
                        for i in self.categoryResult {
                            category.append(i.name)
                            self.categoryStates.append(i.default)
                        }
                        var sortOrder: [String] = []
                        if self.root == "자산" {
                            sortOrder = self.sortAssetOrder
                        } else if self.root == "지출" {
                            sortOrder = self.sortOutcomeOrder
                        } else if self.root == "수입" {
                            sortOrder = self.sortIncomeOrder
                        } else if self.root == "이체" {
                            sortOrder = self.sortTransferOrder
                        }
                        var sortedCategories: [String] {
                            let orderedCategories = category.filter { sortOrder.contains($0) }
                                .sorted { sortOrder.firstIndex(of: $0)! < sortOrder.firstIndex(of: $1)! }
                            let additionalCategories = category.filter { !sortOrder.contains($0) }
                                .sorted(by: <)

                            return orderedCategories + additionalCategories
                        }
                        self.categories = sortedCategories
                    }
                    
                }
            }.store(in: &cancellableSet)
    }
    func postLines() {
        guard !isApiCalling else { return }
        isApiCalling = true
        LoadingManager.shared.update(showLoading: true, loadingType: .floneyLoading)
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        nickname = Keychain.getKeychainValue(forKey: .userNickname) ?? ""
        var moneyDouble : Double = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: money) {
            moneyDouble = number.doubleValue
            print(moneyDouble)  // 출력: 4500.0
        } else {
            print("Cannot convert to Double")
        }
        let request = LinesRequest(bookKey: bookKey, money: moneyDouble, lineDate: selectedDateStr, flow: flow, asset: asset, line: line, description: description, except: except, nickname: nickname, repeatDuration: repeatDuration.rawValue)
        print("내역 추가 request : \(request)")
        dataManager.postLines(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.isApiCalling = false
                    if dataResponse.error!.initialError.isSessionTaskError {
                        AlertManager.shared.update(showAlert: true, message: "요청한 시간이 초과되었습니다.", buttonType: .red)
                    } else {
                        self.createAlert(with: dataResponse.error!, retryRequest: {
                            self.postLines()
                        })
                    }
                } else {
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.isApiCalling = false
                    self.lineResult = dataResponse.value!
                    print("--성공--")
                    print(self.lineResult)
                    self.alertManager.update(showAlert: true, message: "저장이 완료되었습니다.", buttonType: .green)
                    self.successAdd = true
                }
            }.store(in: &cancellableSet)
    }
    func handleUserSelection(_ selection: String, index: Int) {
        if let durationType = durationMapping[selection] {
            self.repeatDuration = durationType
            self.selectedRepeat = selection
            self.selectedDurationIndex = index
        }
    }
    func postCategory() {
        guard !isApiCalling else { return }
        isApiCalling = true
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = AddCategoryRequest(parent: root, name: newCategoryName)
        dataManager.postCategory(request, bookKey: bookKey)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.isApiCalling = false
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.postCategory()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.isApiCalling = false
                    self.getCategory()
                    self.successAddCategory = true
                    self.alertManager.update(showAlert: true, message: "추가 완료되었습니다.", buttonType: .green)
                }
            }.store(in: &cancellableSet)
    }
    
    func deleteCategory() {
        guard !isApiCalling else { return }
        isApiCalling = true
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = DeleteCategoryRequest(parent: root, name: deleteCategoryName)
        dataManager.deleteCategory(parameters: request,bookKey: bookKey)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    print(" successfully category delete.")
                    self.alertManager.update(showAlert: true, message: "삭제가 완료되었습니다.", buttonType: .green)
                    self.isApiCalling = false
                    self.getCategory()
                case .failure(let error):
                    self.isApiCalling = false
                    //self.createAlert(with: error, retryRequest: {
                    //    self.deleteCategory()
                    //})
                    print("Error deleting category: \(error)")
                    if error.initialError.isSessionTaskError {
                        AlertManager.shared.update(showAlert: true, message: "요청한 시간이 초과되었습니다.", buttonType: .red)
                    } else {
                        // 다른 종류의 에러 처리
                        self.createAlert(with: error, retryRequest: {
                            self.deleteCategory()
                        })
                    }
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func deleteLine() {
        guard !isApiCalling else { return }
        isApiCalling = true
        let request = DeleteLineRequest(bookLineKey: bookLineKey)
        dataManager.deleteLine(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isApiCalling = false
                    print(" successfully line delete.")
                    self.alertManager.update(showAlert: true, message: "삭제가 완료되었습니다.", buttonType: .green)
                    self.successAdd = true

                case .failure(let error):
                    self.isApiCalling = false
                    self.createAlert(with: error, retryRequest: {
                        self.deleteLine()
                    })
                    print("Error deleting line: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changeLine() {
        guard !isApiCalling else { return }
        isApiCalling = true
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        nickname = Keychain.getKeychainValue(forKey: .userNickname) ?? ""
        var moneyDouble : Double = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: money) {
            moneyDouble = number.doubleValue
            print(moneyDouble)  // 출력: 4500.0
        } else {
            print("Cannot convert to Double")
        }
        let request = ChangeLineRequest(lineId: bookLineKey, bookKey: bookKey, money: moneyDouble, lineDate: selectedDateStr, flow: flow, asset: asset, line: line, description: description, except: except, nickname: nickname)
        print("내역 수정 request : \(request)")
        dataManager.changeLine(parameters: request)
            .sink {(dataResponse) in
                
                if dataResponse.error != nil {
                    self.isApiCalling = false
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.changeLine()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.isApiCalling = false
                    self.lineResult = dataResponse.value!
                    print("--수정 성공--")
                    print(self.lineResult)
                    self.alertManager.update(showAlert: true, message: "수정이 완료되었습니다.", buttonType: .green)
                    self.successAdd = true
                    
                }
            }.store(in: &cancellableSet)
        
    }
    
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
