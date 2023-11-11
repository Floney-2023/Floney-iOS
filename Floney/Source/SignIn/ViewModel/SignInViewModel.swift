//
//  SignInViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/01.
//

import Foundation
import Combine
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import AdSupport
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


enum ProviderType {
    case email
    case kakao
    case google
    case apple
}

@MainActor
class SignInViewModel: ObservableObject {
    private var appleSignInCoordinator: SignInWithAppleCoordinator?
    var tokenViewModel = TokenReissueViewModel()
    
    @Published var buttonType : ButtonType = .red
    @Published var result : SignInResponse = SignInResponse(accessToken: "", refreshToken: "")
    @Published var signInLoadingError: String = ""
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var email = ""
    @Published var password = ""
    @Published var nickname = ""
    @Published var providerStatus : ProviderType = .email

    @Published var isNextToServiceAgreement = false
    @Published var hasJoined: Bool = false
    @Published var authToken = ""
    @Published var isShowingBottomSheet = false
    @Published var isShowingLogin = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SignInProtocol
    
    init( dataManager: SignInProtocol = SignIn.shared) {
        self.dataManager = dataManager
    }
    
    //MARK: 이메일 로그인
    func postSignIn() {
        let request = SignInRequest(email: email, password: password)
        dataManager.postSignIn(request)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.postSignIn()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.setToken()
                    //IAPManager.shared.getSubscriptionStatus()
                    if (AuthenticationService.shared.isUserLoggedIn == false){
                        self.setEmailPassword(provider: .email)
                        AuthenticationService.shared.logIn()
                    }
                    print("--성공--")
                    print(self.result)
                    BookExistenceViewModel.shared.getBookExistence()
                }
            }.store(in: &cancellableSet)
    }
    
    //MARK: 카카오 회원가입 되어있는지 체크
    func checkKakao() {
        dataManager.checkKakao(authToken)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    //self?.errorMessage = (self?.getErrorMessage(from: error as! NetworkError))!
                    self?.createAlert(with: error as! NetworkError, retryRequest: {
                        self?.checkKakao()
                    })
                case .finished:
                    break
                }
            } receiveValue: { [weak self] joined in
                self?.hasJoined = joined
                if let hasJoined = self?.hasJoined {
                    if hasJoined { // 회원가입 되어있으면 로그인
                        print("체크성공 -> 카카오 로그인")
                        self?.kakaoSignIn()
                    } else { // 안 되어 있으면 회원가입
                        print("체크성공 -> 카카오 회원가입")
                        self?.providerStatus = .kakao
                        self?.isNextToServiceAgreement = true
                        
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    //MARK: 구글 회원가입 되어있는지 체크
    func checkgoogle()  {
        dataManager.checkgoogle(authToken)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    //self?.errorMessage = (self?.getErrorMessage(from: error as! NetworkError))!
                    //print(self?.errorMessage)
                    self?.createAlert(with: error as! NetworkError, retryRequest: {
                        self?.checkgoogle()
                    })
                case .finished:
                    break
                }
            } receiveValue: { [weak self] joined in
                self?.hasJoined = joined
                if let hasJoined = self?.hasJoined {
                    if hasJoined {
                        print("체크성공 -> 구글 로그인")
                        self?.googleSignIn()
                    } else {
                        print("체크성공 -> 구글 회원가입")
                        self?.providerStatus = .google
                        self?.isNextToServiceAgreement = true
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    //MARK: 애플 회원가입 되어있는지 체크
    func checkApple()  {
        dataManager.checkApple(authToken)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    //self?.errorMessage = (self?.getErrorMessage(from: error as! NetworkError))!
                    //print(self?.errorMessage)
                    self?.createAlert(with: error as! NetworkError, retryRequest: {
                        self?.checkApple()
                    })
                case .finished:
                    break
                }
            } receiveValue: { [weak self] joined in
                self?.hasJoined = joined
                if let hasJoined = self?.hasJoined {
                    if hasJoined {
                        print("체크성공 -> 애플 로그인")
                        self?.appleSignIn()
                    } else {
                        print("체크성공 -> 애플 회원가입")
                        self?.providerStatus = .apple
                        self?.isNextToServiceAgreement = true
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    //MARK: 앱 서버로 카카오 로그인
    func kakaoSignIn() {
        dataManager.kakaoSignIn(authToken)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.kakaoSignIn()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.setToken()
                    // 자동로그인을 한 경우는 isLoggedIn이 true이므로 email과 password를 다시 저장하지 않아도 괜찮다.
                    //IAPManager.shared.getSubscriptionStatus()
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
    //MARK: 앱 서버로 구글 로그인
    func googleSignIn() {
        dataManager.googleSignIn(authToken)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.googleSignIn()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    //self.isNext = true
                    print("--성공--")
                    print("로그인 성공 후 : \n\(self.result.accessToken)")
                    print("set token 호출 전")
                    self.setToken()
                    print("set token 호출 후")
                    //IAPManager.shared.getSubscriptionStatus()
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
    //MARK: 앱 서버로 애플 로그인
    func appleSignIn() {
        dataManager.appleSignIn(authToken)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.appleSignIn()
                    })
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    //self.isNext = true
                    print("--성공--")
                    print("로그인 성공 후 : \n\(self.result.accessToken)")
                    print("set token 호출 전")
                    self.setToken()
                    print("set token 호출 후")
                    // 자동로그인을 한 경우는 isLoggedIn이 true이므로 email과 password를 다시 저장하지 않아도 괜찮다.
                    // 자동로그인을 한 경우는 isLoggedIn이 true이므로 email과 password를 다시 저장하지 않아도 괜찮다.
                    //IAPManager.shared.getSubscriptionStatus()
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
    
    //MARK: 자동로그인을 위한 email, password 저장하기, 사용자가 이메일과 비밀번호 입력한 경우이다.
    func setEmailPassword(provider : ProviderType) {
        Keychain.setKeychain(email, forKey: .email)
        if provider == .email {
            Keychain.setKeychain(password, forKey: .password)
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
    
    //MARK: 자동로그인, 사용자가 입력하지 않아도 이미 저장되어 있는 이메일과 비밀번호를 불러와서 로그인을 진행한다.
    func autoLogin() -> Bool {
        guard let provider = Keychain.getKeychainValue(forKey: .provider) else {
            return false
        }
        
        if provider == "EMAIL" {
            guard let email = Keychain.getKeychainValue(forKey: .email),
                  let password = Keychain.getKeychainValue(forKey: .password) else {
                AuthenticationService.shared.logoutDueToTokenExpiration()
                return false
            }
            self.email = email
            self.password = password
            postSignIn()
            return true
        }
        if provider == "KAKAO" {
            // 토큰 존재 여부 확인하기
            if (AuthApi.hasToken()) {
                UserApi.shared.accessTokenInfo { (_, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            //로그인 필요
                        }
                        else {
                            //기타 에러
                        }
                    }
                    else {
                        //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                        // 사용자 엑세스 토큰 정보 조회(캐시에 저장하여 사용중인 토큰)
                        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("엑세스 토큰 정보 가져오기 성공")
                                _ = accessTokenInfo
                            }
                        }
                    }
                }
            }
            else {
                //로그인 필요
            }
            return true
        }
        if provider == "GOOGLE" {
            
            return true
        }
        if provider == "APPLE" {
            
            return true
        }
        return false
    }
    
    
    
    //MARK: 구글 서버에서 토큰 받아오기
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
       
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        let userProfile = gidSignInResult.user.profile
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let email = gidSignInResult.user.profile?.email
        let nickname = gidSignInResult.user.profile?.name
        var imageUrl : URL? = nil
        if let hasImage = userProfile?.hasImage {
            if hasImage {
                imageUrl = userProfile?.imageURL(withDimension: 0)
            }
        }
        self.authToken = idToken
        self.email = email!
        self.nickname = nickname!
        
        print("id token : \(idToken)")
        print("access token : \(accessToken)")
        print("name: \(String(describing: userProfile?.name))")
        print("given name : \(String(describing: userProfile?.givenName))")
        print("family name : \(String(describing: userProfile?.familyName))")
        
        print("has image : \(String(describing: userProfile?.hasImage))")
        
        print("image url : \(String(describing: userProfile?.imageURL(withDimension: 0)))")
        print("email : \(String(describing: userProfile?.email))")
      
        self.checkgoogle()
    }

    //MARK: 애플 서버에서 토큰 받아오기
    func performAppleSignIn() {
        appleSignInCoordinator = SignInWithAppleCoordinator { userId, name, email, identityToken  in
            print("Sign in successful, user id: \(userId)")
            print("Sign in successful, name: \(name)")
            print("Sign in successful, email: \(email)")
            print("identityToken : \(identityToken)")
            
            if !email.isEmpty && !name.isEmpty {
                Keychain.setKeychain(email, forKey: .appleEmail)
                Keychain.setKeychain(name, forKey: .appleName)
                self.email = email
                self.nickname = name
                
            } else {
                self.email = Keychain.getKeychainValue(forKey: .appleEmail) ?? ""
                self.nickname = Keychain.getKeychainValue(forKey: .appleName) ?? ""
                print(self.email)
                print(self.nickname)
            }
            
            self.authToken = identityToken
            self.checkApple()
            //sendServer
        } onError: { error in
            print("Sign in failed with error: \(error)")
        }
        appleSignInCoordinator?.signIn()
    }
    //MARK: 카카오 서버에서 토큰 받아오기
    func performKakaoSignIn() {
        // view model에 저장해야 함.
        //카카오톡이 깔려있는지 확인하는 함수
        if (UserApi.isKakaoTalkLoginAvailable()) {
            //카카오톡이 설치되어있다면 카카오톡을 통한 로그인 진행
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                if let oauthToken = oauthToken{
                    // 소셜 로그인(회원가입 API CALL)
                    print("성공")
                    
                    UserApi.shared.me() {(user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            let nickname = user?.kakaoAccount?.profile?.nickname
                            let email = user?.kakaoAccount?.email
                            print("nickname : \(nickname)")
                            print("email : \(email)")
                            print("oauthToken : \(oauthToken)")
                            let token = String(describing: oauthToken.accessToken)
                            self.email = email!
                            self.nickname = nickname!
                            self.authToken = token
                            self.checkKakao()
                            // "is_email_valid" = 1;
                            // "is_email_verified" = 1;
                        }
                    }
                }
            }
        }else{
            //카카오톡이 설치되어있지 않다면 사파리를 통한 로그인 진행
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                print(oauthToken?.accessToken)
                print(error)
            }
        }
    }
    
    //MARK: 비밀번호 재설정
    func findPassword(email: String) {
        dataManager.findPassword(email: email)
            .sink { [weak self] completion in
                guard let self = self else {return}
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    self.isShowingBottomSheet = true
                    
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.findPassword(email: email)
                    })
                    LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                    print("Error finding password: \(error)")
                }
            } receiveValue: { [weak self] data in
                guard let self = self else {return}
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    func checkValidation(email: String) -> Bool{
        if !isValidEmail(email) {
            AlertManager.shared.update(showAlert: true, message: ErrorMessage.findPassword01.value, buttonType: .red)
            return false
        }
        return true
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
    /*
    private func getErrorMessage(from error: NetworkError) -> String {
        // Format the error message based on the NetworkError
        // This is just a simple example. You should adjust this to suit your needs.
        if let backendError = error.backendError {
            AlertManager.shared.handleError(ServerError(rawValue: backendError.code)!)
            return backendError.message
        } else {
            return error.initialError.errorDescription ?? "Unknown Error"
        }
    }*/
}
