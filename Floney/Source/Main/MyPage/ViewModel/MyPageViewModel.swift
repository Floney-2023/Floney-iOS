//
//  MyPageViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine
import SwiftUI

final class MyPageViewModel: ObservableObject {
    var alertManager = AlertManager.shared
    var recentBookManager = RecentBookKeyManager()
    var tokenViewModel = TokenReissueViewModel()

    @Published var result : MyPageResponse = MyPageResponse(nickname: "", email: "", profileImg: "", provider: "", lastAdTime: nil, myBooks: [])
    @Published var myPageLoadingError: String = ""
    @Published var errorMessage : String = ""
    @Published var showAlert: Bool = false
    @Published var nickname : String = "" {
        didSet {
            if nickname.count > 8 {
                nickname = String(nickname.prefix(8))
            }
        }
    }
    @Published var email : String = ""
    @Published var provider : String = ""
    @Published var userImg : String?
    @Published var profileUrl : String?
    @Published var myBooks : [MyBookResult] = []
    @Published var changedNickname = "" {
        didSet {
            if changedNickname.count > 8 {
                changedNickname = String(changedNickname.prefix(8))
            }
        }
    }
    //MARK: Image
    @Published var imageLoading: Bool = true
    @Published var ChangeProfileImageSuccess : Bool = false
    @Published var encryptedImageUrl : String = ""
    @Published var userPreviewImage124 : UIImage? = nil
    @Published var userPreviewImage36 : UIImage? = nil
    @Published var userPreviewImage32 : UIImage? = nil
    @Published var randomNumStr : String? = nil
    
    //MARK: password
    @Published var currentPassword: String = ""
    @Published var newPassword : String = ""
    @Published var newPasswordCheck : String = ""
    @Published var successChangePassword = false
    
    //MARK: signout
    @Published var selectedReason : SignOutType?
    @Published var otherReason = "" {
        didSet {
            if otherReason.count > 100 {
                otherReason = String(otherReason.prefix(100))
            }
        }
    }
    @Published var showSignoutAlert = false
    @Published var isNextToSuccessSignout = false
    @Published var deletedBookKeys : [String] = []
    @Published var otherBookKeys : [String] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    lazy var dataManager: MyPageProtocol = MyPage.shared
    
    init() { //dataManager: MyPageProtocol = MyPage.shared
        self.dataManager = dataManager
    }
    deinit {
        
    }
    
    
    func getMyPage() {
        dataManager.getMyPage()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getMyPage()
                    })
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print(self.result.myBooks)
                    print(self.result)
                    self.nickname = self.result.nickname
                    self.email = self.result.email
                    self.myBooks = self.result.myBooks!
                    self.userImg = self.result.profileImg
                    self.provider = self.result.provider
                    Keychain.setKeychain(self.provider, forKey: .provider)
                    
                    if let img = self.userImg {
                        if img == "user_default" { // 디폴트라면
                            ProfileManager.shared.setUserImageStateToDefault()
                        } else if img.hasPrefix("random") { // 랜덤이라면
                            ProfileManager.shared.setRandomProfileImage(randomNumStr: img)
                        } else if self.isValidImageURL(img){ // 커스텀 프로필 이미지라면
                            //let decryptedUrl = self.cryptionManager.decrypt(self.userImg!, using: self.cryptionManager.key!) // 복호화
                            self.profileUrl = img
                            print("로드된 이미지 url : \(self.profileUrl)")
                            ProfileManager.shared.setUserImageStateToCustom(urlString: img)
                        } else {
                            ProfileManager.shared.setUserImageStateToDefault()
                        }
                    } else {
                        ProfileManager.shared.setUserImageStateToDefault()
                    }
                    self.loadUserPreviewImage()
                    
                }
            }.store(in: &cancellableSet)
    }
    // 이미지 url 형식 검증
    func isValidImageURL(_ urlString: String) -> Bool {
        let pattern = "^https://firebasestorage\\.googleapis\\.com/"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        return regex.firstMatch(in: urlString, options: [], range: NSRange(location: 0, length: urlString.count)) != nil
    }
    func changeProfile(imageStatus: String) {
        var requestImage : String
        if imageStatus == "default" {
            requestImage = "user_default"
        } else if imageStatus == "random" {
            requestImage = self.randomNumStr!
            print("random number : \(randomNumStr!)")
        } else {
            requestImage = self.encryptedImageUrl
            print("My Page ViewModel Change User Image \(self.encryptedImageUrl)")
        }
        
        dataManager.changeProfile(img: requestImage)
            .sink { completion in

                switch completion {
                case .finished:
                    LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    self.ChangeProfileImageSuccess = true
                    self.alertManager.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                    print("Profile successfully changed.")
                    if imageStatus == "default" {
                        ProfileManager.shared.setUserImageStateToDefault() // 싱글톤으로 관리되는 profile manager에 저장
                    } else if imageStatus == "random" {
                        ProfileManager.shared.setRandomProfileImage(randomNumStr: self.randomNumStr!)
                    } else {
                        ProfileManager.shared.setUserImageStateToCustom(urlString: self.encryptedImageUrl) // 싱글톤으로 관리되는 profile manager에 저장
                    }
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.changeProfile(imageStatus: imageStatus)
                    })
                    LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    print("Error changing profile: \(error)")
                }
            } receiveValue: { [weak self] data in
            
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changeNickname() {
        dataManager.changeNickname(nickname: changedNickname)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                    Keychain.setKeychain(self.changedNickname, forKey: .userNickname)
                    self.alertManager.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.changeNickname()
                    })
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func isValidChangedName() -> Bool {
        if changedNickname.isEmpty {
            AlertManager.shared.handleError(InputValidationError.emptyNickname)
            return false
        }
        return true
    }
    func changePassword() {
        dataManager.changePassword(password: newPassword)
            .sink { completion in

                switch completion {
                case .finished:
                    print("Password successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "비밀번호 변경이 완료되었습니다", buttonType: .green)
                    self.successChangePassword = true
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.changePassword()
                    })
                    print("Error changing password: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    // 비밀번호 검증
    func isValidInputs() -> Bool {
        let currentPasswordEntered = isCurrentPasswordEntered()
        let newPasswordEntered = isNewPasswordEntered()
        let newPasswordCheckEntered = isNewPasswordCheckEntered()
        let newPasswordValid = isNewPasswordValid()
        let passwordMatch = doPasswordsMatch()
        
        if !currentPasswordEntered {
            showAlert = true
            errorMessage = "현재 비밀번호를 입력해주세요."
        }
        else if !newPasswordEntered {
            showAlert = true
            errorMessage = "새 비밀번호를 입력해주세요."
        }
        else if !newPasswordCheckEntered {
            showAlert = true
            errorMessage = "새 비밀번호 확인을 입력해주세요."
        }
        else if !newPasswordValid {
            showAlert = true
            errorMessage = "비밀번호 양식을 확인해주세요."
        }
        else if !passwordMatch {
            showAlert = true
            errorMessage = "새 비밀번호가 일치하지 않습니다."
        }
        alertManager.update(showAlert: showAlert, message: errorMessage, buttonType: .red)
        return  currentPasswordEntered && newPasswordEntered && newPasswordCheckEntered && newPasswordValid && passwordMatch
    }
    
    func isCurrentPasswordEntered() -> Bool {
        return !currentPassword.isEmpty
    }
    func isNewPasswordEntered() -> Bool {
        return !newPassword.isEmpty
    }
    func isNewPasswordCheckEntered() -> Bool {
        return !newPasswordCheck.isEmpty
    }
    
    func isNewPasswordValid() -> Bool {
        // Checking if password is at least 8 characters long and contains at least one alphabet and one number
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$")
        return passwordTest.evaluate(with: newPassword)
    }
    
    func doPasswordsMatch() -> Bool {
        return newPassword == newPasswordCheck
    }
    
    func logout() {
        dataManager.logout()
            .sink { completion in
                
                switch completion {
                case .finished:
                    print("logout success.")
                    AppLinkManager.shared.hasDeepLink = false
                    AppLinkManager.shared.settlementStatus = false
                    DispatchQueue.main.async {
                        AuthenticationService.shared.logoutDueToTokenExpiration()
                    }
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.logout()
                    })
                    print("Error logout: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func signout() {
        print("signout 시도")
        let dispatchGroup = DispatchGroup()
        if let selectedReason = selectedReason {
            var request = SignOutRequest(type: selectedReason.rawValue)
            if selectedReason == .OTHER {
                request = SignOutRequest(type: selectedReason.rawValue, reason: otherReason)
            } else {
                request = SignOutRequest(type: selectedReason.rawValue)
            }
            dataManager.signout(request)
                .sink { (dataResponse) in
                    if dataResponse.error != nil {
                        self.createAlert(with: dataResponse.error!, retryRequest: {
                            self.signout()
                        })
                        print("signout 실패")
                    } else {
                        print("signout 성공")
                        print("signout success.")
                        let fcmManager = FCMDataManager()
                        self.deletedBookKeys = dataResponse.value!.deletedBookKeys
                        for book in self.deletedBookKeys {
                            dispatchGroup.enter()
                            fcmManager.deleteBookTokens(bookKey: book) {
                                dispatchGroup.leave()
                            }
                            dispatchGroup.enter()
                            let firebaseManager = FirebaseManager()
                            firebaseManager.getPreviousImageRef(in: "books/\(book)/") { reference in
                                reference?.delete { error in
                                    if let error = error {
                                        print("Error deleting previous image: \(error)")
                                    } else {
                                        print("Previous image successfully deleted")
                                    }
                                }
                                dispatchGroup.leave()
                            }
                        }
                        let email = Keychain.getKeychainValue(forKey: .email) ?? ""
                        self.otherBookKeys = dataResponse.value!.otherBookKeys
                        for book in self.otherBookKeys {
                            dispatchGroup.enter()
                            fcmManager.deleteUserToken(bookKey: book, email: email) {
                                dispatchGroup.leave()
                            }
                        }
                        
                        dispatchGroup.enter()
                        let firebaseManager = FirebaseManager()
                        firebaseManager.getPreviousImageRef(in: "users/\(email)/") { reference in
                            reference?.delete { error in
                                if let error = error {
                                    print("Error deleting previous image: \(error)")
                                } else {
                                    print("Previous image successfully deleted")
                                }
                            }
                            dispatchGroup.leave()
                        }
                        
                        dispatchGroup.notify(queue:.main) {
                            AppLinkManager.shared.hasDeepLink = false
                            AppLinkManager.shared.settlementStatus = false
                            self.isNextToSuccessSignout = true
                        }
                    }
                }.store(in: &cancellableSet)
        }
    }
    func checkPassword(password : String) {
        print("비밀번호 체크 시도")
        dataManager.checkPassword(password)
            .sink { completion in
                switch completion {
                case .finished:
                    print("비밀번호 검사 성공")
                    print("signout success.")
                    self.showSignoutAlert = true
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.checkPassword(password: password)
                    })
                    print("비밀번호 검사 실패")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
        
    }
    // 회원탈퇴 검증
    func isValidSignout() -> Bool {
        if selectedReason == nil {
            AlertManager.shared.handleError(InputValidationError.notSelectSignoutReason)
            return false
        } else {
            if selectedReason == .OTHER {
                if otherReason.isEmpty  {
                    AlertManager.shared.handleError(InputValidationError.noInputSignoutOtherReason)
                    return false
                }
            }
        }
        return true
    }

    func changeBook(bookKey : String) { //bookStatus : String) {
        Keychain.setKeychain(bookKey, forKey: .bookKey)
        //Keychain.setKeychain(bookStatus, forKey: .bookStatus)
        let recentBookKeyManager = RecentBookKeyManager()
        recentBookKeyManager.saveRecentBookKey(bookKey: bookKey)
        CurrencyManager.shared.getCurrency()
        getMyPage()
    }
    // preview image를 설정한다.
    func loadUserPreviewImage() {
        self.userPreviewImage124 = ProfileManager.shared.userPreviewImage124?.copied()
        self.userPreviewImage36 = ProfileManager.shared.userPreviewImage36?.copied()
        self.userPreviewImage32 = ProfileManager.shared.userPreviewImage32?.copied()
    }
    func sortedBooks() -> [MyBookResult] {
        let selectedBookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        
        return myBooks.sorted {
            if $0.bookKey == selectedBookKey {
                return true
            }
            if $1.bookKey == selectedBookKey {
                return false
            }
            return false // or any other default sorting if needed
        }
    }
    
    // random profile을 설정한다.
    func setRandomProfileImage() {
        // 여기에서 랜덤 이미지를 선택하고 imageState를 업데이트합니다.
        let randomNumber = Int.random(in: 0...5)
        switch randomNumber {
        case 0:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_00_124")
            randomNumStr = "random0"
        case 1:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_01_124")
            randomNumStr = "random1"
        case 2:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_02_124")
            randomNumStr = "random2"
        case 3:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_03_124")
            randomNumStr = "random3"
        case 4:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_04_124")
            randomNumStr = "random4"
        case 5:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_05_124")
            randomNumStr = "random5"
        default:
            userPreviewImage124 = UIImage(named: "img_user_random_profile_00_124")
            randomNumStr = "random0"
        }
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
}
