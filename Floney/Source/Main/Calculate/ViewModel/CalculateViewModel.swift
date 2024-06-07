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
    var fcmManager = FCMDataManager()
    var tokenViewModel = TokenReissueViewModel()
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    
    //MARK: 유저 조회
    @Published var bookUsers : [BookUsersResponse] = []
    @Published var userList : [String] = []
    
    //MARK: 날짜 선택
    @Published var startDate : Date? = Date()
    @Published var endDate : Date? = Date()
    @Published var selectedStartDateStr = ""
    @Published var startDateStr : String = "2023-10-12"
    @Published var endDateStr : String = "2023-10-13"
    @Published var selectedDates: [Date] = []
    @Published var selectedDatesStr = ""
    
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    @Published var passedDays = 0
    @Published var isActiveLines = false
    
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
    @Published var settlementResult : AddSettlementResponse = AddSettlementResponse(id: 0, userCount: 3, startDate: "2023-10-23", endDate: "2023-10-24", totalOutcome: 30000, outcome: 10000, details: []) //AddSettlementResponse(id: 0, userCount: 0, startDate: "", endDate: "", totalOutcome: 0, outcome: 0, details: [])
    @Published var userCount = 3//0
    @Published var totalOutcome : Double = 30000//0
    @Published var outcomePerUser : Double = 10000//0
    @Published var details : [AddSettlementResponseDetails] = [ //[]
        AddSettlementResponseDetails(money: 0, userNickname: "test", userProfileImg: "user_default"),
        AddSettlementResponseDetails(money: -10000, userNickname: "test2", userProfileImg: "user_default"),
        AddSettlementResponseDetails(money: 10000, userNickname: "test3", userProfileImg: "user_default")
    ]
    @Published var id = 0
    
    //MARK: 정산 내역 조회 리스트
    @Published var settlementList : [SettlementListResponse] = []
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalculateProtocol
    
    
    init( dataManager: CalculateProtocol = CalculateService.shared) {
        self.dataManager = dataManager
        extractDate()
    }
    //MARK: 지출 내역
    func getSettlements() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SettlementRequest(bookKey: bookKey, usersEmails: userList, duration: SettlementDate(startDate: startDateStr, endDate: endDateStr))
        
        dataManager.getSettlements(request)
            .sink {  (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getSettlements()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.lines = dataResponse.value!
                    print("--성공--")
                    print(self.lines)
                    if self.lines.isEmpty {
                        self.isActiveLines = false
                        AlertManager.shared.update(showAlert: true, message: "내역이 없습니다. 기간을 다시 설정해주세요.", buttonType: .red)
                        
                    } else {
                        self.isActiveLines = true
                        self.lines = self.lines.map { item in
                            var item = item
                            item.isSelected = false
                            return item
                        }
                    }
                }
                
            }.store(in: &cancellableSet)
    }
    //MARK: 정산하기
    func postSettlements() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let bookName = Keychain.getKeychainValue(forKey: .bookName) ?? ""
        let request = AddSettlementRequest(bookKey: bookKey, userEmails: userList, startDate: startDateStr, endDate: endDateStr, outcomes: outcomeRequest)
        
        dataManager.postSettlements(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.postSettlements()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                } else {
                    print("--정산 요청 성공--")
                    self.fcmManager.fetchTokensFromDatabase(bookKey: bookKey, title: "플로니", body: "\(bookName) 가계부를 정산해보세요!",completion: {})
                    self.postNoti(title: "플로니", body: "\(bookName) 가계부를 정산해보세요!", imgUrl: "icon_noti_settlement")
                    self.settlementResult = dataResponse.value!
                    print(self.settlementResult)
                    self.userCount = self.settlementResult.userCount
                    self.totalOutcome = self.settlementResult.totalOutcome
                    self.outcomePerUser = self.settlementResult.outcome
                    self.details = self.settlementResult.details
                    self.id = self.settlementResult.id
                    
                }
            }.store(in: &cancellableSet)
    }
    // 가계부 user의 알림을 서버에 저장한다.
    func postNoti(title :String, body: String, imgUrl : String) {
        let currentDate = Date()
        let formatter = ISO8601DateFormatter()
        
        let formattedDate = formatter.string(from: currentDate)
        let userEmails = self.userList
        var viewModel = NotiViewModel()
        if let currentUser = Keychain.getKeychainValue(forKey: .email) {
            
            let filtered = userEmails.filter { $0 != currentUser }
            
            for user in filtered {
                viewModel.postNoti(title: title, body: body, imgUrl: imgUrl, userEmail: user, date: formattedDate)
            }
        }
    }
    
    //MARK: 정산 내역 리스트
    func getSettlementList() {
        dataManager.getSettlementList()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getSettlementList()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                } else {
                    print("--정산 내역 요청 성공--")
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.settlementList = dataResponse.value!
                    print(self.settlementList)
                    
                    self.updateDateFormats()
                    
                }
            }.store(in: &cancellableSet)
    }
    // 날짜 형식을 변환하는 함수
    func formatDateString(_ dateString: String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    // SettlementListResponse 배열을 업데이트하는 함수
    func updateDateFormats() {
        for i in 0..<settlementList.count {
            settlementList[i].startDate = formatDateString(settlementList[i].startDate, fromFormat: "yyyy-MM-dd", toFormat: "yyyy.MM.dd")
            settlementList[i].endDate = formatDateString(settlementList[i].endDate, fromFormat: "yyyy-MM-dd", toFormat: "yyyy.MM.dd")
        }
    }
    func getSettlementDetail(id : Int) {
        dataManager.getSettlementDetail(id: id)
            .sink {  (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getSettlementDetail(id: id)
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                } else {
                    print("--정산 내역 디테일 요청 성공--")
                    
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.settlementResult = dataResponse.value!
                    self.startDateStr = self.settlementResult.startDate
                    self.endDateStr = self.settlementResult.endDate
                    self.startDateStr = self.formatDateString(self.startDateStr, fromFormat: "yyyy-MM-dd", toFormat: "yyyy.MM.dd")
                    self.endDateStr = self.formatDateString(self.endDateStr, fromFormat: "yyyy-MM-dd", toFormat: "yyyy.MM.dd")
                    
                    self.userCount = self.settlementResult.userCount
                    self.totalOutcome = self.settlementResult.totalOutcome
                    self.outcomePerUser = self.settlementResult.outcome
                    self.details = self.settlementResult.details
                    print(self.settlementResult)
                }
            }.store(in: &cancellableSet)
    }
    
    func getBookUsers() {
        dataManager.getBookUsers()
            .sink { (dataResponse) in
                
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getBookUsers()
                    })
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
    func getPassedDays() {
        dataManager.getPassedDays()
            .sink {  (dataResponse) in
                
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getPassedDays()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                    
                } else {
                    print("--마지막 정산일 요청 성공--")
                    self.passedDays = dataResponse.value?.passedDays ?? 0
                    
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
