//
//  CalendarViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine
class CalendarViewModel: ObservableObject {
    @Published var result : CalendarResponse = CalendarResponse(totalIncome: 0, totalOutcome: 0, expenses: [])
    @Published var expenses : [CalendarExpenses] = []
    @Published var calendarLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey = ""
    @Published var requestDate: String = ""
    
    
    //MARK: Today
    @Published var todayYear: Int = 0
    @Published var todayMonth: Int = 0
    @Published var todayDay: Int = 0
    var totalToday = ""

    //MARK: Selected Date
    @Published var selectedDate: Date = Date()
    @Published var selectedYear: Int = 0
    @Published var selectedMonth: Int = 0
    @Published var selectedDay: Int = 0
    @Published var selectedYearMonth = ""
    @Published var selectedDateStr = ""
    
    @Published var totalIncome: Int = 0
    @Published var totalOutcome: Int = 0
    
    @Published var selectedView: Int = 1
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    
    //MARK: Day Lines
    @Published var dayLinesDate: String = ""
    @Published var dayLinesResult : DayLinesResponse = DayLinesResponse(dayLinesResponse: [], totalExpense: [], seeProfileImg: true)
    @Published var dayLinesTotalIncome : Int = 0
    @Published var dayLinesTotalOutcome : Int = 0
    //@Published var dayLinesTotalExpenses : [DayTotalExpenses?] = []
    @Published var dayLines : [DayLinesResults?] = []
    @Published var seeProfileImg : Bool = true

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalendarProtocol
    
    init( dataManager: CalendarProtocol = CalendarService.shared) {
        self.dataManager = dataManager
       // getCalendar()
        self.calcToday()
        self.calcDate(Date())
    }
    
    //MARK: server
    func getCalendar() {
        bookKey = "2FE56430"
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
                    self.totalIncome = self.result.totalIncome
                    self.totalOutcome = self.result.totalOutcome
                    self.expenses = self.result.expenses
                }
            }.store(in: &cancellableSet)
    }
    func getDayLines() {
        bookKey = "2FE56430"
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
                            self.dayLinesTotalIncome += asset!.money
                        } else if asset?.assetType == "OUTCOME" {
                            self.dayLinesTotalOutcome += asset!.money
                        }
                    }
                    self.dayLines = self.dayLinesResult.dayLinesResponse
                    self.seeProfileImg = self.dayLinesResult.seeProfileImg
                    
                }
            }.store(in: &cancellableSet)
    }

    func calcToday() {
        let today = Date()
        todayYear = Calendar.current.component(.year, from: today)
        todayMonth = Calendar.current.component(.month, from: today)
        todayDay = Calendar.current.component(.day, from: today)
        
        totalToday = "\(todayYear)-\(todayMonth)-\(todayDay)"
    }
    
    func calcDate(_ date: Date) {
        selectedYear = Calendar.current.component(.year, from: date)
        selectedMonth = Calendar.current.component(.month, from: date)
        selectedDay = Calendar.current.component(.day, from: date)
        
        selectedDateStr = "\(selectedYear)-\(selectedMonth)-\(selectedDay)"
        selectedYearMonth = "\(selectedYear).\(selectedMonth)"
        if (selectedMonth < 10) {
            requestDate = "\(selectedYear)-0\(selectedMonth)-01"
        } else {
            requestDate = "\(selectedYear)-\(selectedMonth)-01"
        }
        print("requestDate : \(requestDate)")
        //getCalendar()
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
               
                let result = "\(year)-\(month)-\(day)"
                
                print(result)
                dates.append(result)
            }
        }
        print(dates)
        return dates
    }
    func extractDay(from dateString: String) -> String {
        let components = dateString.split(separator: "-")
        let dayComponent = components.last
        return String(describing: dayComponent!)
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
        // 에러 처리
    }
    
}
