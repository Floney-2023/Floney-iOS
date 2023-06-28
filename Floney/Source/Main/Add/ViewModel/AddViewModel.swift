//
//  AddViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation
import Combine
class AddViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var categoryResult : [CategoryResponse] = []
    @Published var categories : [String] = []
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var bookKey = ""
    @Published var root = ""
    
    //MARK: line
    @Published var lineResult : LinesResponse = LinesResponse(money: 0, flow: "", asset: "", line: "", description: "", except: false, nickname: "")
    @Published var money = ""
    @Published var lineDate = ""
    @Published var flow = ""
    @Published var asset = ""
    @Published var line = ""
    @Published var description = ""
    @Published var except = false
    @Published var nickname = ""
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: AddProtocol
    
    init( dataManager: AddProtocol = AddService.shared) {
        self.dataManager = dataManager
    }
    
    //MARK: server
    func getCategory() {
        bookKey = "2FE56430"
        let request = CategoryRequest(bookKey: bookKey, root: root)
        dataManager.getCategory(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.categoryResult = dataResponse.value!
                    print("--성공--")
                    print(self.categoryResult)
                    DispatchQueue.main.async {
                        self.categories = []
                        for i in self.categoryResult {
                            self.categories.append(i.name)
                            print(i.name)
                        }
                        print(self.categories)
                    }
                    
                }
            }.store(in: &cancellableSet)
    }
    func postLines() {
        bookKey = "2FE56430"
        nickname = "너구리"
        let moneyInt = Int(money)
        print(moneyInt)
        let request = LinesRequest(bookKey: bookKey, money: moneyInt!, lineDate: lineDate, flow: flow, asset: asset, line: line, description: description, except: except, nickname: nickname)
        dataManager.postLines(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.lineResult = dataResponse.value!
                    print("--성공--")
                    print(self.lineResult)
                   
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
