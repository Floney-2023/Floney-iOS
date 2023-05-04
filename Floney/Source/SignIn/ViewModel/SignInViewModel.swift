//
//  SignInViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/01.
//

import Foundation
import Combine
class SignInViewModel: ObservableObject {
    
    @Published var result : SignInResult = SignInResult(accessToken: "", refreshToken: "")
    @Published var signInLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var email = ""
    @Published var password = ""

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SignInProtocol
    
    init( dataManager: SignInProtocol = SignIn.shared) {
        self.dataManager = dataManager
        //postSignIn()
    }
    
    func postSignIn() {
        let request = SignInRequest(email: email, password: password)
        dataManager.postSignIn(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.result = dataResponse.value!.result!
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError) {
        signInLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
