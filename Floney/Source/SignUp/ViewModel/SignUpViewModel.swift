//
//  SignUpViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/04.
//

import Foundation
import Combine
class SignUpViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()

    @Published var result : SignUpResponse = SignUpResponse(accessToken: "", refreshToken: "")
    @Published var signUpLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var errorMessage = ""
    
    @Published var email = ""
    @Published var password = ""
    @Published var passwordCheck = ""
    @Published var nickname = ""
    @Published var isNextToAuthCode = false
    @Published var isNext = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SignUpProtocol
    
    init( dataManager: SignUpProtocol = SignUp.shared) {
        self.dataManager = dataManager
    }
    
    func postSignUp() {
        let request = SignUpRequest(email: email, password: password, nickname: nickname)
        dataManager.postSignUp(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    self.setToken()
                    self.setEmailPassword()

                    print(self.result.accessToken)
                }
            }.store(in: &cancellableSet)
    }
    func kakaoSignUp(_ token: String) {
        let request = SignUpRequest(email: email, password: password, nickname: nickname)
        dataManager.kakaoSignUp(request, token)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    self.setToken()
                    self.setEmailPassword()
                    print(self.result.accessToken)
                }
                
            }.store(in: &cancellableSet)
    }
    func googleSignUp(_ token: String) {
        let request = SignUpRequest(email: email, password: password, nickname: nickname)
        dataManager.googleSignUp(request, token)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    self.setToken()
                    self.setEmailPassword()
                    print(self.result.accessToken)
                }
                
            }.store(in: &cancellableSet)
    }
    //MARK: 토큰 저장하기
    func setToken() {
        Keychain.setKeychain(self.result.accessToken, forKey: .accessToken)
        Keychain.setKeychain(self.result.refreshToken, forKey: .refreshToken)
        
    }
    //MARK: 자동로그인을 위한 email, password 저장하기, 사용자가 이메일과 비밀번호 입력한 경우이다.
    func setEmailPassword() {
        Keychain.setKeychain(email, forKey: .email)
        Keychain.setKeychain(password, forKey: .password)
        Keychain.setKeychain(nickname, forKey: .userNickname)
    }
    
    
    func authEmail() {
        let request = AuthEmailRequest(email: email)
        dataManager.authEmail(request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("call auth email successfully changed.")
                    
                case .failure(let error):
                    print("Error calling auth email : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
                print(data)
            }
            .store(in: &cancellableSet)
         
    }
     
    func validatePassword() {
        if (password != passwordCheck) {
        }
    }
    
    func checkEmail() {
            if email.isEmpty {
                errorMessage = ErrorMessage.signup02.value
                showAlert = true
                isNextToAuthCode = false
            } else if !isValidEmail(email) {
                errorMessage = ErrorMessage.signup03.value
                showAlert = true
                isNextToAuthCode = false
            } else {
                //isNextToAuthCode = true
                self.authEmail()
            }
        }
    //MARK: 이메일 정규식 체크
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func createAlert( with error: NetworkError) {
        signUpLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        if let errorCode = error.backendError?.code {
            switch errorCode {
            case "U009" :
                print("\(errorCode) : alert")
                self.showAlert = true
                self.errorMessage = ErrorMessage.login01.value
                // 토큰 재발급
            case "U006" :
                tokenViewModel.tokenReissue()
                // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
            //case "U007" :
                //self.postSignIn()
            default:
                break
            }
        }
        
    }
}
