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
    
    @Published var tokenViewModel = TokenReissueViewModel()
    @Published var ChangeProfileImageSuccess = false
    @Published var bookInfoLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var shareUrl : String?
    
    @Published var bookKey = ""
    
    @Published var result : BookInfoResponse = BookInfoResponse(bookImg: nil, bookName: "", startDay: "", seeProfileStatus: true, carryOver: true, ourBookUsers: [])
    @Published var bookUsers : [BookUsers] = []
    @Published var bookImg : String?
    @Published var bookName = ""
    @Published var startDay = ""
    @Published var carryOver = true
    @Published var stateOfCarryOver = false
    
    
    @Published var changedName = ""
    @Published var encryptedImageUrl : String = ""
    @Published var profileStatus = true
    
    @Published var budget : Float = 0
    @Published var asset : Float = 0
    
    @Published var role = "방장"
    
    @Published var bookPreviewImage124: UIImage?
    @Published var bookPreviewImage34: UIImage?
    @Published var bookPreviewImage36: UIImage?
    @Published var userImages : [String]?
    
    @Published var bookCode : String = ""
    
    @Published var currency : String = CurrencyManager.shared.currentCurrencyUnit
    
    //MARK: Excel
    @Published var excelURL : URL?
    @Published var shareExcelStatus = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SettingBookProtocol
    
    init( dataManager: SettingBookProtocol = SettingBookService.shared) {
        self.dataManager = dataManager
    }
    //MARK: server
    func getBookInfo() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
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
                    self.bookUsers.sort {
                        if $0.me != $1.me {
                            return $0.me
                        } else {
                            // Here you can return the secondary criteria if `me` is equal.
                            // For instance, you can sort by name.
                            return $0.name < $1.name
                        }
                    }
                    self.bookImg = self.result.bookImg
                    
                    self.bookName = self.result.bookName
                    self.startDay = self.result.startDay
                    self.carryOver = self.result.carryOver
                    self.profileStatus = self.result.seeProfileStatus
                    self.hostFilter()
                    
                    self.userImages = self.bookUsers.compactMap { $0.profileImg }
                    
                    if let url = self.bookImg {
                        //let decryptedUrl = self.cryprionManager.decrypt(url, using: self.cryprionManager.key!)
                        ProfileManager.shared.setBookImageStateToCustom(urlString: url)
                    } else {
                        ProfileManager.shared.setBookImageStateToDefault()
                    }
                    self.loadBookPreviewImage()
                }
            }.store(in: &cancellableSet)
    }
    
    func changeProfile(inputStatus: String) {
        
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
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
                    
                    DispatchQueue.main.async {
                        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    }
                    self.ChangeProfileImageSuccess = true
                    
                    if inputStatus == "default" {
                        ProfileManager.shared.setBookImageStateToDefault()
                    } else {
                        ProfileManager.shared.setBookImageStateToCustom(urlString: self.encryptedImageUrl)
                    }
                    DispatchQueue.main.async {
                        AlertManager.shared.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                    }
                    
                case .failure(let error):
                    print("Error changing profile: \(error)")
                    self.createAlert(with: error)
                    DispatchQueue.main.async {
                        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
                    }
                    
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    func changeNickname() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookNameRequest(name: changedName, bookKey: bookKey)
        dataManager.changeNickname(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Changing nickname successfully changed.")
                    AlertManager.shared.update(showAlert: true, message: "변경이 완료되었습니다.", buttonType: .green)
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func isValidChangedName() -> Bool {
        if changedName.isEmpty {
            AlertManager.shared.handleError(InputValidationError.emptyBookName)
            return false
        }
        return true
    }
    func changeProfileStatus() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
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
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetBudgetRequest(bookKey: bookKey, budget: budget, date: "")
        dataManager.setBudget(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Setting Budget successfully changed.")
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func setAsset() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetAssetRequest(bookKey: bookKey, asset: asset)
        dataManager.setAsset(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Setting Asset successfully changed.")
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Error changing nickname: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func setCarryOver(status : Bool)  {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetCarryOver(bookKey: bookKey, status: status)
        dataManager.setCarryOver(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Setting Carry Over successfully changed.")
                    self.getBookInfo()
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Error Settig Carry Over: \(error)")
                    
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func exitBook() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.exitBook(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Exit Book successfully changed.")
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Error Exiting Book : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func deleteBook() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.deleteBook(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Exit Book successfully changed.")
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Error Exiting Book : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func resetBook() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.resetBook(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Reset Book successfully changed.")
                case .failure(let error):
                    self.createAlert(with: error)
                    print("Reset Exiting Book : \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    
    func getShareCode() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = BookInfoRequest(bookKey: bookKey)
        dataManager.getShareCode(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.bookCode = (dataResponse.value!.code)
                    print("--성공--")
                    print(self.bookCode)
                }
            }.store(in: &cancellableSet)
    }
    func setCurrency(currency : String) {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = SetCurrencyRequest(requestCurrency: currency, bookKey: bookKey)
        dataManager.setCurrency(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.currency = dataResponse.value!.myBookCurrency
                    print("--성공--")
                    print("변경된 화폐 단위 : \(self.currency)")
                    DispatchQueue.main.async {
                        CurrencyManager.shared.getCurrency()
                    }
                    AlertManager.shared.update(showAlert: true, message: "화폐 단위가 변경 완료 되었습니다.", buttonType: .green)
                }
            }.store(in: &cancellableSet)
    }
    
    func downloadExcelFile() {
        bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let cancellable = dataManager.downloadExcelFile(bookKey: bookKey)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    
                    break
                case .failure(let error):
                   //x self.createAlert(with: error)
                    print("Error downloading Excel file:", error.localizedDescription)
                }
            }, receiveValue: { localFileURL in
                print("Excel file saved to:", localFileURL)
                self.excelURL = localFileURL
                self.shareExcelStatus = true
            })
            .store(in: &cancellableSet)
    }
    func shareExcelWithSNS() {
        
        
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
    func loadBookPreviewImage() {
        self.bookPreviewImage124 = ProfileManager.shared.bookPreviewImage124
        self.bookPreviewImage36 = ProfileManager.shared.bookPreviewImage36
        self.bookPreviewImage34 = ProfileManager.shared.bookPreviewImage34
    }
    
    func createAlert( with error: NetworkError) {
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
                    AuthenticationService.shared.logoutDueToTokenExpiration()
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
