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
    @Published var categoryType = ""
    @Published var favoriteLineList : [FavoriteLineResponse] = []
    @Published var isApiCalling: Bool = false
    @Published var successStatus: Bool = false
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ManageFavoriteLineProtocol
    
    init(dataManager: ManageFavoriteLineProtocol = ManageFavoriteLineService.shared) {
        self.dataManager = dataManager
    }
    
    func getFavoriteLine() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = FavoriteLineRequest(bookKey: bookKey, categoryType: categoryType)
        dataManager.getFavoriteLine(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getFavoriteLine()
                    })
                } else {
                    self.favoriteLineList = dataResponse.value!
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
