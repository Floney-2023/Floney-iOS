//
//  CalendarViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine
class CalendarViewModel: ObservableObject {
    
    @Published var result : CalendarResponse = CalendarResponse(totalIncome: 0, totalOutcome: 0)
    @Published var calendarLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey = ""
    @Published var date = ""
    
    @Published var monthlyData: [CalendarExpenses] = []
    @Published var selectedDate: CalendarExpenses?

    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalendarProtocol
    
    init( dataManager: CalendarProtocol = CalendarService.shared) {
        self.dataManager = dataManager
        getCalendar()
        //postSignIn()
    }
    
    func getCalendar() {
        let request = CalendarRequest(bookKey: bookKey, date: date)
        dataManager.getCalendar(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print("--성공--")
                    print(self.result.totalIncome)
                }
            }.store(in: &cancellableSet)
    }

    func selectDate(_ date: CalendarExpenses) {
        selectedDate = date
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

    
    func createAlert( with error: NetworkError) {
        calendarLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        // 에러 처리
    }
    
}
