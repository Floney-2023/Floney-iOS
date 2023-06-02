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

@MainActor
class SignInViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var signUpViewModel = SignUpViewModel()
    
    @Published var result : SignInResponse = SignInResponse(accessToken: "", refreshToken: "")
    @Published var signInLoadingError: String = ""
    @Published var errorMessage = ""
    @Published var showAlert: Bool = false
    @Published var email = ""
    @Published var password = ""
    
    @Published var isNext = false
    var isLoggedIn = false
    @Published var hasJoined: Bool = false
    @Published var token = ""

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
                    self.setToken()
                    // 자동로그인을 한 경우는 isLoggedIn이 true이므로 email과 password를 다시 저장하지 않아도 괜찮다.
                    if (self.isLoggedIn == false) {self.setEmailPassword()}
                    print("--성공--")
                    print(self.result.accessToken)
                }
            }.store(in: &cancellableSet)
    }
    
    func checkKakao(token : String) {
        dataManager.checkKakao(token)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = (self?.getErrorMessage(from: error as! NetworkError))!
                    print(self?.errorMessage)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] joined in
                self?.hasJoined = joined
                if let hasJoined = self?.hasJoined {
                    if hasJoined {
                        print("체크성공 -> 카카오 로그인")
                        self?.kakaoSignIn(token: token)
                    } else {
                        print("체크성공 -> 카카오 회원가입")
                        self?.signUpViewModel.kakaoSignUp(token)
                    }
                }

            }
            .store(in: &cancellableSet)
        
    }
    func checkgoogle()  {
        dataManager.checkgoogle(token)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = (self?.getErrorMessage(from: error as! NetworkError))!
                    print(self?.errorMessage)
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
                        self?.signUpViewModel.googleSignUp(self!.token)
                    }
                }
            }
            .store(in: &cancellableSet)
    }
    
    func kakaoSignIn(token : String) {
        dataManager.kakaoSignIn(token)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    self.setToken()
                    // 자동로그인을 한 경우는 isLoggedIn이 true이므로 email과 password를 다시 저장하지 않아도 괜찮다.
                    if (self.isLoggedIn == false) {self.setEmailPassword()}
                    print("--성공--")
                    print(self.result.accessToken)
                }
            }.store(in: &cancellableSet)
    }
    //MARK: Connect with our server
    func googleSignIn() {
        dataManager.googleSignIn(token)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNext = true
                    self.setToken()
                    // 자동로그인을 한 경우는 isLoggedIn이 true이므로 email과 password를 다시 저장하지 않아도 괜찮다.
                    if (self.isLoggedIn == false) {self.setEmailPassword()}
                    print("--성공--")
                    print(self.result.accessToken)
                }
            }.store(in: &cancellableSet)
    }
    //MARK: Connect with google
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
        self.token = idToken
        signUpViewModel.email = email!
        signUpViewModel.nickname = nickname!
        signUpViewModel.provider = "google"
        
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
    
    //MARK: 토큰 저장하기
    func setToken() {
        Keychain.setKeychain(self.result.accessToken, forKey: .accessToken)
        Keychain.setKeychain(self.result.refreshToken, forKey: .refreshToken)
        
    }
    
    //MARK: 자동로그인을 위한 email, password 저장하기, 사용자가 이메일과 비밀번호 입력한 경우이다.
    func setEmailPassword() {
        Keychain.setKeychain(email, forKey: .email)
        Keychain.setKeychain(password, forKey: .password)
        self.isLoggedIn = true
    }
    
    //MARK: 자동로그인, 사용자가 입력하지 않아도 이미 저장되어 있는 이메일과 비밀번호를 불러와서 로그인을 진행한다.
    func autoLogin() -> Bool {
        guard let email = Keychain.getKeychainValue(forKey: .email),
                let password = Keychain.getKeychainValue(forKey: .password) else {
            self.isLoggedIn = false
            return false
        }
        self.isLoggedIn = true
        self.email = email
        self.password = password
        postSignIn()
        return true
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
            case "U007" :
                self.postSignIn()
            default:
                break
            }
            // 에러 처리
        }
    }
    
    private func getErrorMessage(from error: NetworkError) -> String {
        // Format the error message based on the NetworkError
        // This is just a simple example. You should adjust this to suit your needs.
        if let backendError = error.backendError {
            return backendError.message
        } else {
            return error.initialError.errorDescription ?? "Unknown Error"
        }
    }
}
