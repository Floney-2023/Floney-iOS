//
//  ManageFavoriteLineViewModel.swift
//  Floney
//
//  Created by 남경민 on 5/21/24.
//

import Foundation
import Combine
import Alamofire
class ManageFavoriteLineViewModel : ObservableObject {
    var alertManager = AlertManager.shared
    @Published var tokenViewModel = TokenReissueViewModel()
    @Published var bookKey = ""
    @Published var categoryType = ""
    @Published var favoriteLineList : [FavoriteLineResponse] = []
    @Published var isApiCalling: Bool = false
    @Published var successStatus: Bool = false
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var successAdd = false
    
    @Published var money = ""
    @Published var lineCategoryName = ""
    @Published var assetSubcategoryName = ""
    @Published var lineSubcategoryName = ""
    @Published var description = ""

    
    var dataManager: ManageFavoriteLineProtocol
    
    init(dataManager: ManageFavoriteLineProtocol = ManageFavoriteLineService.shared) {
        self.dataManager = dataManager
    }
    
    func getFavoriteLine() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = FavoriteLineRequest(bookKey: bookKey, categoryType: categoryType)
        print(request)
        dataManager.getFavoriteLine(request)
            .sink { (dataResponse) in
                print(dataResponse)
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getFavoriteLine()
                    })
                } else {
                    self.favoriteLineList = dataResponse.value!
                    
                }
            }.store(in: &cancellableSet)
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
    
    func addFavoriteLine() {
        guard !isApiCalling else { return }
        isApiCalling = true
        LoadingManager.shared.update(showLoading: true, loadingType: .floneyLoading)
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        var moneyDouble : Double = 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: money) {
            moneyDouble = number.doubleValue
            print(moneyDouble)  // 출력: 4500.0
        } else {
            print("Cannot convert to Double")
        }
        let request = AddFavoriteLineRequest(money: moneyDouble, description: description, lineCategoryName: lineCategoryName, lineSubcategoryName: lineSubcategoryName, assetSubcategoryName: assetSubcategoryName)
        dataManager.addFavoriteLine(request, bookKey: bookKey)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.isApiCalling = false
                    if dataResponse.error!.initialError.isSessionTaskError {
                        AlertManager.shared.update(showAlert: true, message: "요청한 시간이 초과되었습니다.", buttonType: .red)
                    } else {
                        self.createAlert(with: dataResponse.error!, retryRequest: {
                            self.addFavoriteLine()
                        })
                    }
                } else {
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.isApiCalling = false
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
            if error.backendError?.code != "U006" && error.backendError?.code != "B001"{
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
