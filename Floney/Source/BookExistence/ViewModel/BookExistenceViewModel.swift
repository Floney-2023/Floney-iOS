//
//  BookExistenceViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/07/17.
//
import Foundation
import Combine

class BookExistenceViewModel: ObservableObject {
    static let shared = BookExistenceViewModel()
    var currencyManager = CurrencyManager.shared
    var recentBookManager = RecentBookKeyManager()
    var fcmManager = FCMDataManager()
    var tokenViewModel = TokenReissueViewModel()
    @Published var result : BookExistenceResponse = BookExistenceResponse()
    @Published var loadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey : String = ""
    @Published var bookExistence = false
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: BookExistenceProtocol
    
    init( dataManager: BookExistenceProtocol = BookExistenceService.shared) {
        self.dataManager = dataManager
        
    }
    
    //MARK: server
    func getBookExistence() {
        dataManager.getBookExistence()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        print("토큰 재발급 성공")
                        self.getBookExistence()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print("--성공--")
                    print(self.result)
                    if let book = self.result.bookKey {
                        print("가계부 있음")
                        self.bookKey = book
                        Keychain.setKeychain(self.bookKey, forKey: .bookKey)
                        self.bookExistence = true
                        if let email = Keychain.getKeychainValue(forKey: .email), let fcmToken = Keychain.getKeychainValue(forKey: .fcmToken) {
                            self.fcmManager.saveToken(for: email, bookKey: book, token: fcmToken)
                        }
                        if let bookKey = Keychain.getKeychainValue(forKey: .bookKey) {
                            self.recentBookManager.saveRecentBookKey(bookKey: bookKey)
                            self.currencyManager.getCurrency()
                        }
                    } else {
                        print("가계부 없음")
                        self.bookExistence = false
                    }

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
            AlertManager.shared.handleError(serverError)
            // 에러 메시지 처리
            //showAlert(message: serverError.errorMessage)
            
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
