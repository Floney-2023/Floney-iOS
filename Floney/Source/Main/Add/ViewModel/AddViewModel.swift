//
//  AddViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation
import Combine
class AddViewModel: ObservableObject {
    var fcmManager = FCMDataManager()
    var tokenViewModel = TokenReissueViewModel()
    var alertManager = AlertManager.shared
    @Published var successAdd = false
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var bookKey = ""
    
    //MARK: line
    @Published var lineResult : LinesResponse = LinesResponse(money: 0, flow: "", asset: "", line: "", lineDate: "", description: "", except: false, nickname: "")
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
    @Published var newCategoryName = "" {
        didSet {
            if newCategoryName.count > 6 {
                newCategoryName = String(newCategoryName.prefix(6))
            }
        }
    }

    @Published var deleteCategoryName = ""
    
    //MARK: delete line
    @Published var bookLineKey : Int = 0

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: AddProtocol
    
    init( dataManager: AddProtocol = AddService.shared) {
        self.dataManager = dataManager
    }
    func isValidCategoryName() -> Bool {
        if newCategoryName.isEmpty {
            alertManager.handleError(InputValidationError.categoryNameEmpty)
            return false
        }
        return true
    }
    func isVaildAdd(money: String, asset: String, category: String) -> Bool {
        if money.isEmpty || money == "0" {
            alertManager.handleError(InputValidationError.moneyEmpty)
            return false
        }
        if asset == "자산을 선택하세요" {
            alertManager.handleError(InputValidationError.assetTypeEmpty)
            return false
        }
        if category == "분류를 선택하세요" {
            alertManager.handleError(InputValidationError.categoryTypeEmpty)
            return false
        }
        return true
    }
    
    //MARK: server
    func getCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = CategoryRequest(bookKey: bookKey, root: root)
        dataManager.getCategory(request)
            .sink {(dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getCategory()
                    })
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
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        nickname = Keychain.getKeychainValue(forKey: .userNickname) ?? ""
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
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.postLines()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.lineResult = dataResponse.value!
                    print("--성공--")
                    print(self.lineResult)
                    self.alertManager.update(showAlert: true, message: "저장이 완료되었습니다.", buttonType: .green)
                    self.successAdd = true
                }
            }.store(in: &cancellableSet)
    }
    func postCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = AddCategoryRequest(bookKey: bookKey, parent: root, name: newCategoryName)
        dataManager.postCategory(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.postCategory()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    print("--카테고리 추가 성공--")
                    print(dataResponse.value)
                    self.getCategory()
                    self.successAdd = true
                }
            }.store(in: &cancellableSet)
    }
    
    func deleteCategory() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = DeleteCategoryRequest(bookKey: bookKey, root: root, name: deleteCategoryName)
        dataManager.deleteCategory(parameters: request)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    print(" successfully category delete.")
                    self.getCategory()
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.deleteCategory()
                    })
                    print("Error deleting category: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func deleteLine() {
        let request = DeleteLineRequest(bookLineKey: bookLineKey)
        dataManager.deleteLine(parameters: request)
            .sink { completion in

                switch completion {
                case .finished:
                    print(" successfully line delete.")
                    self.getCategory()
                    self.successAdd = true

                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.deleteLine()
                    })
                    print("Error deleting line: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changeLine() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        nickname = Keychain.getKeychainValue(forKey: .userNickname) ?? ""
        var moneyDouble : Double = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: money) {
            moneyDouble = number.doubleValue
            print(moneyDouble)  // 출력: 4500.0
        } else {
            print("Cannot convert to Double")
        }
        let request = ChangeLineRequest(lineId: bookLineKey, bookKey: bookKey, money: moneyDouble, lineDate: lineDate, flow: flow, asset: asset, line: line, description: description, except: except, nickname: nickname)
        print("내역 수정 request : \(request)")
        dataManager.changeLine(parameters: request)
            .sink {(dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.changeLine()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.lineResult = dataResponse.value!
                    print("--수정 성공--")
                    print(self.lineResult)
                    self.alertManager.update(showAlert: true, message: "저장이 완료되었습니다.", buttonType: .green)
                    self.successAdd = true
                    
                }
            }.store(in: &cancellableSet)
        
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
