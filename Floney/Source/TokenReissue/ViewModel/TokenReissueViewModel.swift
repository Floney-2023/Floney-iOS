//
//  TokenReissueViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/17.
//

import Foundation
import Combine
class TokenReissueViewModel: ObservableObject {
    @Published var result : TokenReissueResponse = TokenReissueResponse(accessToken: "", refreshToken: "")
    @Published var tokenReissueLoadingError: String = ""
    @Published var showAlert: Bool = false
  
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: TokenReissueProtocol
    
    init( dataManager: TokenReissueProtocol = TokenReissue.shared) {
        self.dataManager = dataManager
        //postSignIn()
    }
    
    func tokenReissue() {
        if let accessToken = Keychain.getKeychainValue(forKey: .accessToken) ,let refreshToken = Keychain.getKeychainValue(forKey: .refreshToken) {
            print("token reissue----------------")
            let request = TokenReissueRequest(accessToken: accessToken, refreshToken: refreshToken)
            dataManager.tokenReissue(request)
                .sink { (dataResponse) in
                    if dataResponse.error != nil {
                        self.createAlert(with: dataResponse.error!)
                        print(dataResponse.error)
                    } else {
                        self.result = dataResponse.value!
                        print("reissue token : \(self.result)")
                        self.setToken()
                    }
                    
                }.store(in: &cancellableSet)
        }
    }
    //MARK: 토큰 저장하기
    func setToken() {
        Keychain.setKeychain(self.result.accessToken, forKey: .accessToken)
        Keychain.setKeychain(self.result.refreshToken, forKey: .refreshToken)
    }
    
    func createAlert( with error: NetworkError) {
        tokenReissueLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        
        if let errorCode = error.backendError?.code {
            switch errorCode {
                
                // 토큰 재발급
            case "U006" :
                AuthenticationService.shared.logoutDueToTokenExpiration()
            // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
            case "U007" :
                AuthenticationService.shared.logoutDueToTokenExpiration()
            default:
                break
            }
        }

    }
}
