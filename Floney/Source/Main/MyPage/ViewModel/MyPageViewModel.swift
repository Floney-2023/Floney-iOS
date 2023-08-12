//
//  MyPageViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine
import SwiftUI
class MyPageViewModel: ObservableObject {
    var cryptionManager = CryptManager()
    @Published var result : MyPageResponse = MyPageResponse(nickname: "", email: "", profileImg: "", provider: "", subscribe: false, lastAdTime: nil, myBooks: [])
    @Published var myPageLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var nickname : String = ""
    @Published var email : String = ""
    @Published var provider : String = ""
    @Published var userImg : String?
    @Published var myBooks : [MyBookResult] = []
    @Published var encryptedImageUrl : String = ""
    
    @Published var changedNickname = ""
    
    @Published var imageLoading: Bool = true
    @Published var userPreviewImage124 : UIImage? = nil
    @Published var userPreviewImage36 : UIImage? = nil
    @Published var userPreviewImage32 : UIImage? = nil
    
    @Published var randomNumStr : String? = nil
    
    //MARK: password
    @Published var currentPassword: String = ""
    @Published var newPassword : String = ""
    @Published var newPasswordCheck : String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: MyPageProtocol
    
    init( dataManager: MyPageProtocol = MyPage.shared) {
        self.dataManager = dataManager
        //postSignIn()
        //getMyPage()
    }
    
    func getMyPage() {
        dataManager.getMyPage()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
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
                    
                    if self.userImg == "user_default" {
                        ProfileManager.shared.setUserImageStateToDefault()
                    } else if self.userImg!.hasPrefix("random") {
                        ProfileManager.shared.setRandomProfileImage(randomNumStr: self.userImg!)
                    } else {
                        let decryptedUrl = self.cryptionManager.decrypt(self.userImg!, using: self.cryptionManager.key!) // 복호화
                        ProfileManager.shared.setUserImageStateToCustom(urlString: decryptedUrl!)
                    }
                    self.loadUserPreviewImage()
                   
                }
            }.store(in: &cancellableSet)
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
                    print("Profile successfully changed.")
                    if imageStatus == "default" {
                        ProfileManager.shared.setUserImageStateToDefault() // 싱글톤으로 관리되는 profile manager에 저장
                    } else if imageStatus == "random" {
                        ProfileManager.shared.setRandomProfileImage(randomNumStr: self.randomNumStr!)
                    } else {
                        let decryptedUrl = self.cryptionManager.decrypt(self.encryptedImageUrl, using: self.cryptionManager.key!) // 복호화된 url
                        ProfileManager.shared.setUserImageStateToCustom(urlString: decryptedUrl!) // 싱글톤으로 관리되는 profile manager에 저장
                    }
                case .failure(let error):
                    print("Error changing profile: \(error)")
                }
            } receiveValue: { data in
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
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changePassword() {
        dataManager.changePassword(password: newPassword)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Password successfully changed.")
                    Keychain.setKeychain(self.changedNickname, forKey: .userNickname)
                case .failure(let error):
                    print("Error changing password: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func logout() {
        dataManager.logout()
            .sink { completion in
                switch completion {
                case .finished:
                    print("logout success.")
                    AuthenticationService.shared.logoutDueToTokenExpiration()
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func loadUserPreviewImage() {
        self.userPreviewImage124 = ProfileManager.shared.userPreviewImage124
        self.userPreviewImage36 = ProfileManager.shared.userPreviewImage36
        self.userPreviewImage32 = ProfileManager.shared.userPreviewImage32
    }
    
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
    func createAlert( with error: NetworkError) {
        myPageLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
