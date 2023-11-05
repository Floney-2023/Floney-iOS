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
    @Published var buttonType : ButtonType = .red
    
    @Published var providerStatus :ProviderType = .email
    @Published var authToken = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordCheck = ""
    @Published var nickname = "" {
        didSet {
            if nickname.count > 8 {
                nickname = String(nickname.prefix(8))
            }
        }
    }
    
    @Published var marketingAgree = false
    @Published var isNextToServiceAgreement = false
    @Published var isNextToEmailAuth = false
    @Published var isNextToAuthCode = false
    @Published var isNextToUserInfo = false
   // @Published var isNext = false
    @Published var otpCode = ""

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SignUpProtocol
    
    init(dataManager: SignUpProtocol = SignUp.shared) {
        self.dataManager = dataManager
    }
    init(dataManager: SignUpProtocol = SignUp.shared, email: String, authToken: String, nickname: String, providerStatus: ProviderType) {
        self.dataManager = dataManager
        
        self.email = email
        self.authToken = authToken
        self.nickname = nickname
        self.providerStatus = providerStatus
    }
    
    func postSignUp() {
        let request = SignUpRequest(email: email, password: password, nickname: nickname, receiveMarketing: marketingAgree)
        dataManager.postSignUp(request)
            .sink { (dataResponse) in
    
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.postSignUp()
                    })
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
           
                    self.setToken()
                    if (AuthenticationService.shared.isUserLoggedIn == false) {
                        self.setEmailPassword(provider: .email)
                        AuthenticationService.shared.logIn()
                        
                    }
                    print("--성공--")
                    print(self.result)
                    BookExistenceViewModel.shared.getBookExistence()
                }
            }.store(in: &cancellableSet)
    }
    //MARK: 카카오로 가입하기
    func kakaoSignUp() {
        let request = SNSSignUpRequest(email: email,nickname: nickname, receiveMarketing: marketingAgree)
        dataManager.kakaoSignUp(request, authToken)
            .sink {  (dataResponse) in
                
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.kakaoSignUp()
                    })
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    
                    self.setToken()
                    if (AuthenticationService.shared.isUserLoggedIn == false) {
                        self.setEmailPassword(provider: .kakao)
                        AuthenticationService.shared.logIn()
                        
                    }
                    print("--성공--")
                    print(self.result)
                    BookExistenceViewModel.shared.getBookExistence()
                }
            }.store(in: &cancellableSet)
    }
    //MARK: 구글로 가입하기
    func googleSignUp() {
        let request = SNSSignUpRequest(email: email, nickname: nickname, receiveMarketing: marketingAgree)
        dataManager.googleSignUp(request, authToken)
            .sink { (dataResponse) in
                                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.googleSignUp()
                    })
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                
                    self.setToken()
                    if (AuthenticationService.shared.isUserLoggedIn == false) {
                        self.setEmailPassword(provider: .google)
                        AuthenticationService.shared.logIn()
                        
                    }
                    print("--성공--")
                    print(self.result)
                    BookExistenceViewModel.shared.getBookExistence()
                }
            }.store(in: &cancellableSet)
    }
    //MARK: 애플로 가입하기
    func appleSignUp() {
        let request = SNSSignUpRequest(email: email, nickname: nickname, receiveMarketing: marketingAgree)
        dataManager.appleSignUp(request, authToken)
            .sink {  (dataResponse) in

                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.appleSignUp()
                    })
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                  
                    self.setToken()
                    if (AuthenticationService.shared.isUserLoggedIn == false) {
                        self.setEmailPassword(provider: .apple)
                        AuthenticationService.shared.logIn()
                    }
                    print("--성공--")
                    print(self.result)
                    BookExistenceViewModel.shared.getBookExistence()
                }
            }.store(in: &cancellableSet)
    }

    //MARK: 토큰 저장하기
    func setToken() {
        Keychain.setKeychain(self.result.accessToken, forKey: .accessToken)
        Keychain.setKeychain(self.result.refreshToken, forKey: .refreshToken)
    }
    //MARK: 자동로그인을 위한 email, password 저장하기
    func setEmailPassword(provider : ProviderType) {
        Keychain.setKeychain(email, forKey: .email)
        Keychain.setKeychain(nickname, forKey: .userNickname)
        if provider == .email {
            Keychain.setKeychain("EMAIL", forKey: .provider)
        } else if provider == .kakao {
            Keychain.setKeychain("KAKAO", forKey: .provider)
        } else if provider == .google {
            Keychain.setKeychain("GOOGLE", forKey: .provider)
        } else if provider == .apple {
            Keychain.setKeychain("APPLE", forKey: .provider)
        }
        AuthenticationService.shared.logIn()
    }

    //MARK: EMAIL에 인증코드 보내기
    func authEmail() {
        DispatchQueue.main.async {
            LoadingManager.shared.update(showLoading: true, loadingType: .dimmedLoading)
        }
        let request = AuthEmailRequest(email: email)
        dataManager.authEmail(request)
            .sink { completion in
                
                switch completion {
                case .finished:
                    print("call auth email successfully changed.")
                    DispatchQueue.main.async {
                        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    }
                    self.isNextToAuthCode = true
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.authEmail()
                    })
                    DispatchQueue.main.async {
                        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    }
                    print("Error calling auth email : \(error)")
                }
            } receiveValue: { [weak self] data in
                guard let self = self else {return}
                // TODO: Handle the received data if necessary.
                print(data)
            }
            .store(in: &cancellableSet)
    }
    func checkCode() {
        let request = CheckCodeRequest(email: email, code: otpCode)
        print(request)
        dataManager.checkCode(request)
            .sink { completion in
                
                switch completion {
                case .finished:
                    print("call code successfully checked")
                    self.isNextToUserInfo = true
                    
                case .failure(let error):
                    self.createAlert(with: error,
                                     retryRequest: {
                        self.checkCode()
                    })
                }
            } receiveValue: { [weak self] data in
                guard let self = self else {return}
                // TODO: Handle the received data if necessary.
                print(data)
            }
            .store(in: &cancellableSet)
    }
    func validateFields() -> Bool {
        if providerStatus != .email {
            // 간편 로그인의 경우
            if nickname.isEmpty {
                // nickname이 비어 있으면
                AlertManager.shared.handleError(InputValidationError.emptyNickname)
                return false
            }
        } else {
            // 일반 로그인의 경우
            if password.isEmpty  {
                
                AlertManager.shared.handleError(InputValidationError.emptyPassword)
                return false
            }
            if passwordCheck.isEmpty {
                AlertManager.shared.handleError(InputValidationError.emptyPasswordCheck)
                return false
            }
            if !isValidPassword(password) {
                AlertManager.shared.handleError(InputValidationError.passwordInvaid)
                return false
            }
            if (password != passwordCheck) {
                AlertManager.shared.handleError(InputValidationError.checkPassword)
                return false
            }
            if nickname.isEmpty {
                // nickname이 비어 있으면
                AlertManager.shared.handleError(InputValidationError.emptyNickname)
                return false
            }
        }
        return true
    }
    func isValidPassword(_ password: String) -> Bool {
        // 조건:
        // 1. 8자 이상
        // 2. 영문 포함
        // 3. 숫자 포함
        // 4. 특수문자 포함
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
     
    
    //MARK: email 형식 검증
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
                self.authEmail()
            }
        }
    //MARK: 이메일 정규식 체크
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
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
