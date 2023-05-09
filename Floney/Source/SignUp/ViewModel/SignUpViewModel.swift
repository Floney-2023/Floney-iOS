//
//  SignUpViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/04.
//

import Foundation
import Combine
class SignUpViewModel: ObservableObject {
    @Published var result : SignUpResponse = SignUpResponse(accessToken: "", refreshToken: "")
    @Published var signUpLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var email = ""
    @Published var password = ""
    @Published var passwordCheck = ""
    @Published var nickname = ""
    @Published var marketingAgree = 0
    @Published var isNext = false

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
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    let token = Keychain.setKeychain(self.result.accessToken, forKey: .authorization)
                    //let token = Keychain.setKeychain(value: ,forKey: .authorization)
                   
                   
                    print(self.result.accessToken)
                }
                
            }.store(in: &cancellableSet)
    }
    func authEmail() {
        let request = AuthEmailRequest(email: email)
        dataManager.authEmail(request)
        /*
        dataManager.authEmail(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    //self.result = dataResponse.value!
                    //self.isNext = true
                    //let token = Keychain.setKeychain(self.result.accessToken, forKey: .authorization)
                    //let token = Keychain.setKeychain(value: ,forKey: .authorization)
                    print("성공")
                }
                
            }.store(in: &cancellableSet)
         */
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
