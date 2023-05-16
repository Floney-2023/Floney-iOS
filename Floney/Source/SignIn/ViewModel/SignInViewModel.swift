//
//  SignInViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/01.
//

import Foundation
import Combine
import AuthenticationServices

class SignInViewModel: ObservableObject {
    
    @Published var result : SignInResponse = SignInResponse(accessToken: "", refreshToken: "")
    @Published var signInLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var email = ""
    @Published var password = ""
    
    @Published var isNext = false

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
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    print("--성공--")
                    print(self.result.accessToken)
                }
            }.store(in: &cancellableSet)
    }
    
    private func performAppleSignIn() {
        let coordinator = SignInWithAppleCoordinator { userId in
            print("Sign in successful, user id: \(userId)")
        } onError: { error in
            print("Sign in failed with error: \(error)")
        }

        coordinator.signIn()
    }
    
    func createAlert( with error: NetworkError) {
        signInLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        // 에러 처리
    }
}
