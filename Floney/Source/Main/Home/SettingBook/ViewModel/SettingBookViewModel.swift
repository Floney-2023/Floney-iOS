//
//  SettingBookViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation
import Combine

class SettingBookViewModel : ObservableObject {
    @Published var tokenViewModel = TokenReissueViewModel()
    
    @Published var bookInfoLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var bookKey = ""
    
    @Published var result : BookInfoResponse = BookInfoResponse(bookImg: "", bookName: "", startDay: "", ourBookUsers: [])
    @Published var bookUsers : [BookUsers] = []
    @Published var bookImg : String?
    @Published var bookName = ""
    @Published var startDay = ""
    
    @Published var changedName = ""
    @Published var encryptedImageUrl : String = ""
    @Published var profileStatus = true
    
    @Published var budget : Float = 0
    @Published var asset : Float = 0
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SettingBookProtocol
    
    init( dataManager: SettingBookProtocol = SettingBookService.shared) {
        self.dataManager = dataManager
       
    }
    //MARK: server
    func getBookInfo() {
        bookKey = "2FE56430"
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
                }
            }.store(in: &cancellableSet)
    }
    func changeProfile() {
        bookKey = "2FE56430"
        let request = BookProfileRequest(newUrl: encryptedImageUrl, bookKey: bookKey)
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
        bookKey = "2FE56430"
        let request = BookNameRequest(name: changedName, bookKey: bookKey)
        dataManager.changeNickname(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func changeProfileStatus() {
        bookKey = "2FE56430"
        let request = SeeProfileRequest(bookKey: bookKey, seeProfileStatus: profileStatus)
        dataManager.changeProfileStatus(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func setBudget() {
        bookKey = "2FE56430"
        let request = SetBudgetRequest(bookKey: bookKey, budget: budget)
        dataManager.setBudget(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func setAsset() {
        bookKey = "2FE56430"
        let request = SetAssetRequest(bookKey: bookKey, asset: asset)
        dataManager.setAsset(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Profile successfully changed.")
                case .failure(let error):
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError) {
        bookInfoLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        
        if let errorCode = error.backendError?.code {
            switch errorCode {
                //case "U009" :
                //print("\(errorCode) : alert")
                //self.showAlert = true
                //self.errorMessage = ErrorMessage.login01.value
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
