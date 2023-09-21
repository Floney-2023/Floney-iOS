//
//  SendBookCodeViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
class BookCodeViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var result : BookCodeResponse = BookCodeResponse(bookKey: "", code: "")
    @Published var bookCodeLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var code : String = ""
    @Published var isNext : Bool = false
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: BookCodeProtocol
    
    init( dataManager: BookCodeProtocol = BookCode.shared) {
        self.dataManager = dataManager
    }
    
    func postBookCode() {
        let request = BookCodeRequest(code: code)
        dataManager.postBookCode(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    print(self.result.code)
                    BookExistenceViewModel.shared.getBookExistence()
                }
            }.store(in: &cancellableSet)
    }
    func isVaildBookCode() -> Bool {
        if code.isEmpty {
            AlertManager.shared.handleError(InputValidationError.bookCodeEmpty)
            return false
        }
        return true
    }
    func createAlert( with error: NetworkError) {
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
                    tokenViewModel.tokenReissue()
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
