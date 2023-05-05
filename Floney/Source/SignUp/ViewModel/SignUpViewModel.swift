//
//  SignUpViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/04.
//

import Foundation
import Combine
class SignUpViewModel: ObservableObject {
    @Published var result : SignUpResult = SignUpResult(accessToken: "", refreshToken: "")
    @Published var signUpLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var passwordCheck = ""
    @Published var nickname = ""
    @Published var marketingAgree = 0

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SignUpProtocol
    
    init( dataManager: SignUpProtocol = SignUp.shared) {
        self.dataManager = dataManager
        //postSignIn()
    }
    
    func postSignUp() {
        let request = SignUpRequest(email: email, password: password, nickname: nickname, marketingAgree: marketingAgree)
        dataManager.postSignUp(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.result = dataResponse.value!.result!
                }
            }.store(in: &cancellableSet)
    }
    
    func validatePassword() {
        if (password != passwordCheck) {
            
        }
    }
    
    func createAlert( with error: NetworkError) {
        signUpLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
