//
//  CalculateViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import Foundation
import Combine

struct YearMonthDuration {
  let year: Int
  let month: Int
}

class CalculateViewModel : ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var showLoadingView = false
    
    //MARK: 유저 조회
    @Published var bookUsers : [BookUsersResponse] = []
    @Published var userList : [String] = []
    
    //MARK: 날짜 선택
    @Published var startDate : Date? = Date()
    @Published var endDate : Date? = Date()
    @Published var selectedStartDateStr = ""
    @Published var startDateStr : String = ""
    @Published var endDateStr : String = ""
    @Published var selectedDates: [Date] = []
    @Published var selectedDatesStr = ""
    
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    
    // 메인으로 선택된 날짜 -> 이 날짜에 의해 좌우됨.
    @Published var selectedDate: Date = Date() {
        didSet {
            extractDate()
            extractSelectedDatesStr()
        }
    }
    // 2차원 배열 달력
    @Published var daysList : [[Date]] = [[]]
    
    // 피커 뷰에서 선택된 연도, 월
    @Published var yearMonth = YearMonthDuration(year: Date().year, month: Date().month) {
        didSet {
            selectedDate = Date.from(year: yearMonth.year, month: yearMonth.month)
            print("in Year Month 프로퍼티 selectedDate: \(selectedDate)")
        }
    }
    
    //MARK: 정산 지출 내역
    @Published var lines : [SettlementResponse] = []
    @Published var outcomeRequest : [OutComes] = []
    
    //MARK: 정산 요청 완료
    @Published var settlementResult : AddSettlementResponse = AddSettlementResponse(id: 0, userCount: 0, startDate: "", endDate: "", totalOutcome: 0, outcome: 0, details: [])
    @Published var userCount = 0
    @Published var totalOutcome : Float = 0
    @Published var outcomePerUser : Float = 0
    @Published var details : [AddSettlementResponseDetails] = []
    @Published var id = 0
    
    //MARK: 정산 내역 조회 리스트
    @Published var settlementList : [SettlementListResponse] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalculateProtocol
    
    
    init( dataManager: CalculateProtocol = CalculateService.shared) {
        self.dataManager = dataManager
        extractDate()
    }
    //MARK: server
    func getSettlements() {
        userList = ["rudalswhdk12@naver.com","rudalswhdk12@gmail.com"]
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = SettlementRequest(bookKey: bookKey, usersEmails: userList, dates: SettlementDate(startDate: startDateStr, endDate: endDateStr))
        
        dataManager.getSettlements(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.lines = dataResponse.value!
                    print("--성공--")
                    print(self.lines)
                    self.lines = self.lines.map { item in
                        var item = item
                        item.isSelected = false
                        return item
                    }
                }
                
            }.store(in: &cancellableSet)
    }
    func postSettlements() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = AddSettlementRequest(bookKey: bookKey, userEmails: userList, startDate: startDateStr, endDate: endDateStr, outcomes: outcomeRequest)
        
        dataManager.postSettlements(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                    self.showLoadingView = false
                } else {
                    print("--정산 요청 성공--")
                    self.showLoadingView = false
                    self.settlementResult = dataResponse.value!
                    print(self.settlementResult)
                    self.userCount = self.settlementResult.userCount
                    self.totalOutcome = self.settlementResult.totalOutcome
                    self.outcomePerUser = self.settlementResult.outcome
                    self.details = self.settlementResult.details

                }
            }.store(in: &cancellableSet)
    }
    
    func getSettlementList() {
        dataManager.getSettlementList()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                    self.showLoadingView = false
                } else {
                    print("--정산 내역 요청 성공--")
                    self.showLoadingView = false
                    self.settlementList = dataResponse.value!
                    print(self.settlementList)
  
                }
            }.store(in: &cancellableSet)
    }
    func getSettlementDetail() {
        dataManager.getSettlementDetail(id: self.id)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                    self.showLoadingView = false
                } else {
                    print("--정산 내역 디테일 요청 성공--")
                    self.showLoadingView = false
                    self.settlementResult = dataResponse.value!
                    self.startDateStr = self.settlementResult.startDate
                    self.endDateStr = self.settlementResult.endDate
                    
                    self.userCount = self.settlementResult.userCount
                    self.totalOutcome = self.settlementResult.totalOutcome
                    self.outcomePerUser = self.settlementResult.outcome
                    self.details = self.settlementResult.details
                }
            }.store(in: &cancellableSet)
    }
    func getBookUsers() {
        dataManager.getBookUsers()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                    
                } else {
                    print("--유저 리스트 요청 성공--")
                    self.bookUsers = dataResponse.value!
                    print(self.bookUsers)
                    self.bookUsers = self.bookUsers.map { item in
                        var item = item
                        item.isSelected = false
                        return item
                    }
                }
            }.store(in: &cancellableSet)
    }
    func checkUser() {
        // 체크 상태에 따라 배열에 추가/제거
        for user in bookUsers {
            if let selected = user.isSelected {
                if selected {
                    userList.append(user.email)
                }
            }
        }
        print(userList)
    }
    
    func CheckOutcome() {
        for line in lines {
            if let selected = line.isSelected {
                if selected {
                    let outcome = line.money
                    let email = line.userEmail
                    outcomeRequest.append(OutComes(outcome: outcome, userEmail: email))
                }
            }
        }
        print(outcomeRequest)
    }
    // 1주일씩 계산
    func daysInMonth() -> [Date] {
        var dates = [Date]()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.day = 1
        
        let firstDayOfMonth = calendar.date(from: components)!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        if let startDay = calendar.date(byAdding: .day, value: -offsetDays, to: firstDayOfMonth),
           let rangeOfMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth) {
            for i in 0..<(rangeOfMonth.count + offsetDays) {
                if let date = calendar.date(byAdding: .day, value: i, to: startDay) {
                    dates.append(date)
                    print(date)
                }
            }
        }
        
        while dates.count % 7 != 0 {
            if let date = calendar.date(byAdding: .day, value: 1, to: dates.last!) {
                dates.append(date)
                print(date)
            }
        }
        
        return dates
    }
    // 이차원 배열 달력
    func extractDate() {
        var days = daysInMonth()
        //달력과 같은 배치의 이차원 배열로 변환하여 리턴
        var result = [[Date]]()
        days.forEach {
            if result.isEmpty || result.last?.count == 7 {
                result.append([$0])
            } else {
                result[result.count - 1].append($0)
            }
            
        }
        self.daysList = result
        print(daysList)
    }
    
    func extractSelectedDatesStr() {
        if selectedDates.count == 2 {
            if let date1 = selectedDates.first, let date2 = selectedDates.last {
                if date1.year == date2.year {
                    // 연도가 같을 경우
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM.dd"
                    let formattedDate = dateFormatter.string(from: date2)
                    print("연도가 같음 뒤 날짜: \(formattedDate)")
                    let newStartDate = startDateStr.replacingOccurrences(of: "-", with: ".")
                    selectedDatesStr = "\(newStartDate) - \(formattedDate)"
                    print("\(selectedDatesStr)")
                } else {
                    // 연도가 다를 경우
                    print("연도가 다름")
                    let newStartDate = startDateStr.replacingOccurrences(of: "-", with: ".")
                    let newEndDate = endDateStr.replacingOccurrences(of: "-", with: ".")
                    selectedDatesStr = "\(newStartDate) - \(newEndDate)"
                    print("\(selectedDatesStr)")
                }
            }
            let newStartDate = startDateStr.replacingOccurrences(of: "-", with: ".")
            self.selectedStartDateStr = newStartDate
        }
    }
    func createAlert( with error: NetworkError) {
        addLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        // 에러 처리
        
        if let errorCode = error.backendError?.code {
            switch errorCode {
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
