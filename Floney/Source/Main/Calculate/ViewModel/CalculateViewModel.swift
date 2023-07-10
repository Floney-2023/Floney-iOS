//
//  CalculateViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import Foundation
import Combine
class CalculateViewModel : ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var userList : [String] = []
    
    @Published var startDate : Date = Date()
    @Published var endDate : Date = Date()
    @Published var startDateStr : String = ""
    @Published var endDateStr : String = ""
    @Published var daysOfTheWeek = ["일","월","화","수","목","금","토"]
    
    
    @Published var lines : [SettlementResponse] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CalculateProtocol
    
    
    init( dataManager: CalculateProtocol = CalculateService.shared) {
        self.dataManager = dataManager
    }
    //MARK: server
    func getSettlements() {
        let request = SettlementRequest(usersEmails: userList, startDate: startDateStr, endDate: endDateStr)
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
                    
                    
                }
            }.store(in: &cancellableSet)
    }

    func createAlert( with error: NetworkError) {
        addLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
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
