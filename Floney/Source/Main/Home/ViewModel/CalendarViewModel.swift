//
//  CalendarViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    
    @Published var result : CalendarResponse = CalendarResponse(totalIncome: 0, totalOutcome: 0, expenses: [])
    @Published var expenses : [CalendarExpenses] = []
    @Published var calendarLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey = ""
    @Published var requestDate: String = ""  // 0000-00-01
    @Published var options = ["캘린더", "일별"]
        
    //MARK: Today
    @Published var todayYear: Int = 0
    @Published var todayMonth: Int = 0
    @Published var todayDay: Int = 0
    var totalToday = ""

    //MARK: Selected Date
    // 연,월을 바꿀 경우에는 해당 연도 해당 달의 1일로 selected 변화
    // 아래 모든 데이터는 같은 날짜를 가리켜야 함
    // 피커 뷰에서 선택된 연도, 월
    @Published var yearMonth = YearMonthDuration(year: Date().year, month: Date().month)
    
    @Published var selectedDate: Date = Date() // Date type
    @Published var selectedYear: Int = 0 // year
    @Published var selectedMonth: Int = 0 // month
    @Published var selectedDay: Int = 0 // day
    @Published var selectedYearMonth = "" // year.month
    @Published var selectedDateStr = "" // String type 0000-00-00
    
    @Published var totalIncome: Int = 0
    @Published var totalOutcome: Int = 0
    
    @Published var selectedView: Int = 0
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    
    //MARK: Day Lines
    @Published var dayLinesDate: String = ""
    @Published var dayLinesResult : DayLinesResponse = DayLinesResponse(dayLinesResponse: [], totalExpense: [], seeProfileImg: true)
    @Published var dayLinesTotalIncome : Int = 0
    @Published var dayLinesTotalOutcome : Int = 0
    @Published var dayLines : [DayLinesResults?] = []
    @Published var seeProfileImg : Bool = true
    @Published var userImages : [String?]?
    
    //MARK: book profile image
    @Published var bookInfoResult = BookInfoResponse(bookImg: "",bookName: "", startDay: "", seeProfileStatus: true, carryOver: true, ourBookUsers: [])
    @Published var bookProfileImage : String?

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalendarProtocol
    
    init( dataManager: CalendarProtocol = CalendarService.shared) {
        self.dataManager = dataManager
        self.calcToday()
        self.calcDate(Date())
    }
    
    //MARK: server
    func getCalendar() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = CalendarRequest(bookKey: bookKey, date: requestDate)
        dataManager.getCalendar(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
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
                    
                }
            }.store(in: &cancellableSet)
    }
    func getDayLines() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = DayLinesRequest(bookKey: bookKey, date: dayLinesDate)
        dataManager.getDayLines(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.dayLinesResult = dataResponse.value!
                    print("--성공--")
                    
                    print(self.dayLinesResult)
                    
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
                    
                    
                }
            }.store(in: &cancellableSet)
    }
    //MARK: server
    func getBookInfo() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.getBookInfo(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.bookInfoResult = dataResponse.value!
                    print("--성공--")
                    print(self.bookInfoResult)
                    self.bookProfileImage = self.bookInfoResult.bookImg
                    
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


    func nextMonth() {
        selectedMonth += 1
        if selectedMonth > 12 {
            selectedMonth = 1
            selectedYear += 1
        }
        getCalendar()
    }

    func previousMonth() {
        selectedMonth -= 1
        if selectedMonth < 1 {
            selectedMonth = 12
            selectedYear -= 1
        }
        getCalendar()
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()

    func createAlert( with error: NetworkError) {
        calendarLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        
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
