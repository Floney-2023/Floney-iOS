//
//  SettingBookViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation
import Combine
import SwiftUI

class SettingBookViewModel : ObservableObject {
    var cryprionManager = CryptManager()
    @Published var tokenViewModel = TokenReissueViewModel()
    
    @Published var bookInfoLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var bookKey = ""
    
    @Published var result : BookInfoResponse = BookInfoResponse(bookImg: nil, bookName: "", startDay: "", seeProfileStatus: true, carryOver: true, ourBookUsers: [])
    @Published var bookUsers : [BookUsers] = []
    @Published var bookImg : String?
    @Published var bookName = ""
    @Published var startDay = ""
    @Published var carryOver = true
    
    @Published var changedName = ""
    @Published var encryptedImageUrl : String = ""
    @Published var profileStatus = true
    
    @Published var budget : Float = 0
    @Published var asset : Float = 0
    
    @Published var role = "방장"
    
    @Published var previewImage: UIImage?
    @Published var userImages : [String]?

    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SettingBookProtocol
    
    init( dataManager: SettingBookProtocol = SettingBookService.shared) {
        self.dataManager = dataManager
    }
    //MARK: server
    func getBookInfo() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.getBookInfo(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print("--성공--")
                    print(self.result)
                    
                    self.bookUsers = self.result.ourBookUsers
                    self.bookImg = self.result.bookImg
                    
                    self.bookName = self.result.bookName
                    self.startDay = self.result.startDay
                    self.carryOver = self.result.carryOver
                    self.profileStatus = self.result.seeProfileStatus
                    self.hostFilter()
                    
                    self.userImages = self.bookUsers.compactMap { $0.profileImg }
                    
                    if let url = self.bookImg {
                        let decryptedUrl = self.cryprionManager.decrypt(url, using: self.cryprionManager.key!)
                        self.loadImageFromURL(decryptedUrl!)
                    } else {
                        let image = UIImage(named: "book_profile_124")
                        self.previewImage = image
                    }
                }
            }.store(in: &cancellableSet)
    }
    func loadImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.previewImage = image
                }
            } else {
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
    func changeProfile(inputStatus: String) {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        var request : BookProfileRequest
        if inputStatus == "default" {
            request = BookProfileRequest(newUrl: nil, bookKey: bookKey)
        } else {
            request = BookProfileRequest(newUrl: encryptedImageUrl, bookKey: bookKey)
        }
        
        print("book profile parameter : \(request)")
        dataManager.changeProfile(parameters: request)
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
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = BookNameRequest(name: changedName, bookKey: bookKey)
        dataManager.changeNickname(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Changing nickname successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changeProfileStatus() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = SeeProfileRequest(bookKey: bookKey, seeProfileStatus: profileStatus)
        dataManager.changeProfileStatus(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Changing Profile Status successfully changed.")
                case .failure(let error):
                    print("Error changing profile status: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func setBudget() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = SetBudgetRequest(bookKey: bookKey, budget: budget)
        dataManager.setBudget(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Setting Budget successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func setAsset() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let request = SetAssetRequest(bookKey: bookKey, asset: asset)
        dataManager.setAsset(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Setting Asset successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    //MARK: 방장 필터
    func hostFilter() {
        // role이 "방장"이고, me가 true인 요소를 필터링합니다.
        print("가계부 멤버 : \(bookUsers)")
        let filteredUsers = bookUsers.filter { user in
            user.role == "방장" && user.me == true
        }
        if let host = filteredUsers.first {
            print("방장이며, me가 true인 사용자: \(host)")
            role = "방장"
        } else {
            // 조건에 해당하는 사용자가 없을 경우 처리할 작업을 수행합니다.
            print("해당 조건을 만족하는 사용자가 없습니다.")
            role = "팀원"
        }
    }
    
    func createAlert( with error: NetworkError) {
        bookInfoLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        
        if let errorCode = error.backendError?.code {
            switch errorCode {
                // 토큰 재발급
            case "U006" :
                tokenViewModel.tokenReissue()
            // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
            case "U007" :
                AuthenticationService.shared.logoutDueToTokenExpiration()
            default:
                break
            }
            // 에러 처리
        }
    }

}
