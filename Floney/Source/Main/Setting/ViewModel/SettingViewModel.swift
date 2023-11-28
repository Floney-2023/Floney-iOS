//
//  SettingViewModel.swift
//  Floney
//
//  Created by 남경민 on 11/28/23.
//

import Foundation
import Combine

final class SettingViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var marketingAgree = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SettingProtocol
    
    init( dataManager: SettingProtocol = Setting.shared) {
        self.dataManager = dataManager
    }
    func getMarketing() {
        dataManager.getMarketing()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getMarketing()
                        
                    })
                    print(dataResponse.error)
                } else {
                    self.marketingAgree = dataResponse.value?.receiveMarketing ?? false
                    print(self.marketingAgree)
                }
            }.store(in: &cancellableSet)
    }
    
    func postMarketing() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = MarketingRequest(agree: marketingAgree)
        dataManager.postMarketing(request)
            .sink { completion in

                switch completion {
                case .finished:
                    print("postMarketing success.")
                    print(self.marketingAgree)
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.postMarketing()
                    })
                    print("Error posting marketing: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
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

