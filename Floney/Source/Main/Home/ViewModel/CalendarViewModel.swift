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

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalendarProtocol
    
    init( dataManager: CalendarProtocol = CalendarService.shared) {
        self.dataManager = dataManager
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
    
    func createAlert( with error: NetworkError) {
        calendarLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        // 에러 처리
    }
}
