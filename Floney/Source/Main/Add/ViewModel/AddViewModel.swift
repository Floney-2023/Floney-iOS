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
    
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var bookKey = ""

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
    
    //MARK: category
    @Published var categoryResult : [CategoryResponse] = []
    @Published var categories : [String] = []
    @Published var categoryStates : [Bool] = []
    @Published var root = ""
    @Published var newCategoryName = ""
    @Published var deleteCategoryName = ""
    
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: AddProtocol
    
    init( dataManager: AddProtocol = AddService.shared) {
        self.dataManager = dataManager
    }
    
    //MARK: server
    func getCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
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
                        self.categoryStates = []
                        for i in self.categoryResult {
                            self.categories.append(i.name)
                            self.categoryStates.append(i.default)
                            print(i.name)
                        }
                        print(self.categories)
                        print(self.categoryStates)
                    }
                    
                }
            }.store(in: &cancellableSet)
    }
    func postLines() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        nickname = Keychain.getKeychainValue(forKey: .userNickname)!
        //let moneyInt = Double(money)
        //print("money : \(moneyInt)")
        var moneyDouble : Double = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: money) {
            moneyDouble = number.doubleValue
            print(moneyDouble)  // 출력: 4500.0
        } else {
            print("Cannot convert to Double")
        }
        let request = LinesRequest(bookKey: bookKey, money: moneyDouble, lineDate: lineDate, flow: flow, asset: asset, line: line, description: description, except: except, nickname: nickname)
        print("내역 추가 request : \(request)")
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
    func postCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!

        let request = AddCategoryRequest(bookKey: bookKey, parent: root, name: newCategoryName)
        dataManager.postCategory(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    print("--카테고리 추가 성공--")
                    print(dataResponse.value)
                   
                }
            }.store(in: &cancellableSet)
    }
    
    func deleteCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = DeleteCategoryRequest(bookKey: bookKey, root: root, name: deleteCategoryName)
        dataManager.deleteCategory(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print(" successfully category delete.")
                    self.getCategory()
                case .failure(let error):
                    print("Error deleting category: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
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
