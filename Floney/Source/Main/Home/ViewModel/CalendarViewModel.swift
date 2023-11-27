//
//  CalendarViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine
import FirebaseFirestore

class CalendarViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    
    @Published var result : CalendarResponse = CalendarResponse(totalIncome: 0, totalOutcome: 0, expenses: [], carryOverInfo: CarryOverInfo(carryOverStatus: false, carryOverMoney: 0))
    @Published var expenses : [CalendarExpenses] = []
    @Published var calendarLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey = ""
    @Published var options = ["캘린더", "일별"]
    
    //MARK: Today
    @Published var todayYear: Int = 0
    @Published var todayMonth: Int = 0
    @Published var todayDay: Int = 0
    @Published var totalToday = ""
    
    //MARK: Selected Date
    // 연,월을 바꿀 경우에는 해당 연도 해당 달의 1일로 selected 변화
    // 아래 모든 데이터는 같은 날짜를 가리켜야 함
    // 피커 뷰에서 선택된 연도, 월
    @Published var yearMonth = YearMonthDuration(year: Date().year, month: Date().month)
    @Published var requestDate: String = ""  // 0000-00-01
    @Published var selectedDate: Date = Date() // Date type
    @Published var selectedYear: Int = 0 // year
    @Published var selectedMonth: Int = 0 // month
    @Published var selectedDay: Int = 0 // day
    @Published var selectedYearMonth = "" // year.month
    @Published var selectedDateStr = "" // String type 0000-00-00
    
    @Published var totalIncome: Double = 0
    @Published var totalOutcome: Double = 0
    
    @Published var selectedView: Int = 0
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    
    //MARK: Day Lines
    @Published var dayLinesDate: String = ""
    @Published var dayLinesResult : DayLinesResponse = DayLinesResponse(dayLinesResponse: [], totalExpense: [], carryOverInfo: CarryOverInfo(carryOverStatus: false, carryOverMoney: 0), seeProfileImg: true)
    @Published var dayLinesTotalIncome : Double = 0
    @Published var dayLinesTotalOutcome : Double = 0
    @Published var dayLines : [DayLinesResults?] = []
    @Published var seeProfileImg : Bool = true
    @Published var userImages : [String?]?
    @Published var dayLineCarryOver : CarryOverInfo = CarryOverInfo(carryOverStatus: false, carryOverMoney: 0)
    @Published var writer = ""
    
    //MARK: book profile image
    @Published var bookInfoResult = BookInfoResponse(bookImg: "",bookName: "", startDay: "", seeProfileStatus: true, carryOver: true, ourBookUsers: [])
    @Published var bookProfileImage : String?
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalendarProtocol
    
    init( dataManager: CalendarProtocol = CalendarService.shared) {
        self.dataManager = dataManager
        self.getMyInfo()
        self.calcToday()
        self.calcDate(Date())
    }
    
    //MARK: server
    func getCalendar() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = CalendarRequest(bookKey: bookKey, date: requestDate)
        dataManager.getCalendar(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getCalendar()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print("--성공--")
                    print(self.result)
                    print(self.result.totalIncome)
                    self.expenses = self.result.expenses
                    self.totalIncome = self.result.totalIncome
                    self.totalOutcome = self.result.totalOutcome
                    // 이월 내역이 있음
                    if self.result.carryOverInfo.carryOverStatus {
                        if self.result.carryOverInfo.carryOverMoney > 0 {
                            self.totalIncome += Double(self.result.carryOverInfo.carryOverMoney)
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.year, .month], from: self.selectedDate)
                            
                            if let year = components.year, let month = components.month {
                                let firstDayOfMonthString = "\(year)-\(String(format: "%02d", month))-01"
                                
                                if let index = self.expenses.firstIndex(where: { $0.date == firstDayOfMonthString && $0.assetType == "INCOME" }) {
                                    self.expenses[index].money += Double(self.result.carryOverInfo.carryOverMoney)
                                }
                            }
                            
                        } else if self.result.carryOverInfo.carryOverMoney < 0 {
                            self.totalOutcome += Double(self.result.carryOverInfo.carryOverMoney)
                            let calendar = Calendar.current
                            let components = calendar.dateComponents([.year, .month], from: self.selectedDate)
                            
                            if let year = components.year, let month = components.month {
                                let firstDayOfMonthString = "\(year)-\(String(format: "%02d", month))-01"
                                
                                if let index = self.expenses.firstIndex(where: { $0.date == firstDayOfMonthString && $0.assetType == "OUTCOME" }) {
                                    self.expenses[index].money += Double(abs(self.result.carryOverInfo.carryOverMoney))
                                }
                            }
                        }
                        
                        
                    }
                }
            }.store(in: &cancellableSet)
    }
    func getDayLines() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = DayLinesRequest(bookKey: bookKey, date: dayLinesDate)
        print(request)
        dataManager.getDayLines(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getDayLines()
                    })
                    print(dataResponse.error)
                } else {
                    self.dayLinesResult = dataResponse.value!
                    print("--성공--")
                    print(self.dayLinesResult)
                    self.dayLinesTotalIncome = 0
                    self.dayLinesTotalOutcome = 0
                    for asset in self.dayLinesResult.totalExpense {
                        if asset?.assetType == "INCOME" {
                            self.dayLinesTotalIncome = asset!.money
                        } else if asset?.assetType == "OUTCOME" {
                            self.dayLinesTotalOutcome = asset!.money
                        }
                    }
                    self.dayLines = self.dayLinesResult.dayLinesResponse
                    self.seeProfileImg = self.dayLinesResult.seeProfileImg
                    self.userImages = self.dayLines.compactMap { $0?.img }
                    
                    print(self.dayLinesResult.carryOverInfo)
                    self.dayLineCarryOver = self.dayLinesResult.carryOverInfo
                    if self.dayLineCarryOver.carryOverStatus {
                        if self.dayLineCarryOver.carryOverMoney > 0 {
                            self.dayLinesTotalIncome += Double(self.dayLineCarryOver.carryOverMoney)
                        } else if self.dayLineCarryOver.carryOverMoney < 0 {
                            self.dayLinesTotalOutcome += Double(self.dayLineCarryOver.carryOverMoney)
                        }
                    }
                    
                }
                
            }.store(in: &cancellableSet)
    }
    //MARK: server
    func getBookInfo() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.getBookInfo(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getBookInfo()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.bookInfoResult = dataResponse.value!
                    print("--성공--")
                    print(self.bookInfoResult)
                    self.bookProfileImage = self.bookInfoResult.bookImg
                    Keychain.setKeychain(self.bookInfoResult.bookName, forKey: .bookName)
                    
                }
            }.store(in: &cancellableSet)
    }
    func getMyInfo() {
        dataManager.getMyInfo()
            .sink { (dataResponse) in

                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getMyInfo()
                    })
                    print(dataResponse.error)
                } else {
                    print(dataResponse.value?.nickname)
                    if let nickname = dataResponse.value?.nickname {
                        Keychain.setKeychain(nickname, forKey: .userNickname)
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    // MARK: 오늘 날짜 계산
    func calcToday() {
        let today = Date()
        todayYear = Calendar.current.component(.year, from: today)
        todayMonth = Calendar.current.component(.month, from: today)
        todayDay = Calendar.current.component(.day, from: today)
        
        totalToday = "\(todayYear)-\(todayMonth)-\(todayDay)"
    }
    
    // MARK: 선택된 날짜
    func calcDate(_ date: Date) {
        selectedYear = Calendar.current.component(.year, from: date)
        selectedMonth = Calendar.current.component(.month, from: date)
        selectedDay = Calendar.current.component(.day, from: date)
        
        if (selectedMonth < 10) {
            requestDate = "\(selectedYear)-0\(selectedMonth)-01"
            selectedYearMonth = "\(selectedYear).0\(selectedMonth)"
            if ( selectedDay < 10) {
                selectedDateStr = "\(selectedYear)-0\(selectedMonth)-0\(selectedDay)"
            } else {
                selectedDateStr = "\(selectedYear)-0\(selectedMonth)-\(selectedDay)"
            }
        } else {
            requestDate = "\(selectedYear)-\(selectedMonth)-01"
            selectedYearMonth = "\(selectedYear).\(selectedMonth)"
            if ( selectedDay < 10) {
                selectedDateStr = "\(selectedYear)-\(selectedMonth)-0\(selectedDay)"
            } else {
                selectedDateStr = "\(selectedYear)-\(selectedMonth)-\(selectedDay)"
            }
        }
        dayLinesDate = selectedDateStr
        getDayLines()
        print("selectedDate : \(selectedDateStr)")
        print("requestDate : \(requestDate)")
    }
    
    // MARK: 해당 달에 대한 date 반환
    func generateDates(for date: Date, using calendar: Calendar = .current) -> [String] {
        var dates: [String] = []
        
        let components = calendar.dateComponents([.year, .month], from: date)
        var firstDayOfMonth = calendar.date(from: components)!
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let firstDayOfWeek = calendar.component(.weekday, from: firstDayOfMonth)
        
        for _ in 0..<firstDayOfWeek-1 {
            dates.append("0")
        }
        if let monthRange = calendar.range(of: .day, in: .month, for: date) {
            for day in monthRange {
                
                var result = "\(year)-\(month)-\(day)"
                
                if (selectedMonth < 10) {
                    if ( day < 10) {
                        result = "\(year)-0\(month)-0\(day)"
                    } else {
                        result = "\(year)-0\(month)-\(day)"
                    }
                    
                } else {
                    if ( day < 10) {
                        result = "\(year)-\(month)-0\(day)"
                    } else {
                        result = "\(year)-\(month)-\(day)"
                    }
                }
                
                print(result)
                dates.append(result)
            }
        }
        print(dates)
        return dates
    }
    // MARK: 데이 추출
    func extractDay(from dateString: String) -> String {
        let components = dateString.split(separator: "-")
        let dayComponent = components.last
        return String(describing: dayComponent!)
    }
    //MARK: 연, 월 추출 후 검사
    func extractYearMonth(from dateString: String) -> Bool {
        var result = false
        let components = dateString.split(separator: "-")
        
        if let year = Int(components[0]), let month = Int(components[1]) {
            if year == selectedYear && month == selectedMonth {
                result = true
            } else {
                result = false
            }
        }
        return result
    }
    // 이전 달로 이동하는 함수
    func moveOneMonthBackward() {
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)
        selectedDate = newDate ?? selectedDate
        calcDate(selectedDate)
    }
    
    // 다음 달로 이동하는 함수
    func moveOneMonthForward() {
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)
        selectedDate = newDate ?? selectedDate
        calcDate(selectedDate)
    }
    // 하루 전으로 이동하는 함수
    func moveOneDayBackward() {
        let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)
        selectedDate = newDate ?? selectedDate
        calcDate(selectedDate)
    }
    
    // 하루 이후로 이동하는 함수
    func moveOneDayForward() {
        let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)
        selectedDate = newDate ?? selectedDate
        calcDate(selectedDate)
    }

    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    
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
