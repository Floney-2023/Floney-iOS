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
    @Published var result : MyPageResponse = MyPageResponse(nickname: "", email: "", subscribe: false)
    @Published var myPageLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var nickname : String = ""
    @Published var email : String = ""
    @Published var myBooks : [MyBookResult] = []
    @Published var encryptedImageUrl : String = ""
    
    @Published var changedNickname = ""
    
    @Published var userPreviewImage : UIImage?
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: MyPageProtocol
    
    init( dataManager: MyPageProtocol = MyPage.shared) {
        self.dataManager = dataManager
        //postSignIn()
        getMyPage()
    }
    
    func getMyPage() {
        //let request = MyPageRequest(name: name, profileImg: profileImg)
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
                    self.userPreviewImage = UIImage(named: "user_profile_124")
                }
            }.store(in: &cancellableSet)
        
    }
    
    func changeProfile(imageStatus: String) {
        var requestImage : String?
        if imageStatus == "default" {
            requestImage = nil
        } else {
            requestImage = self.encryptedImageUrl
        }
        dataManager.changeProfile(img: requestImage)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
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
    
    func createAlert( with error: NetworkError) {
        myPageLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
