//
//  BookExistenceViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/07/17.
//
import Foundation
import Combine

class BookExistenceViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var result : BookExistenceResponse = BookExistenceResponse()
    @Published var loadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey : String = ""
    @Published var bookExistence = false
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: BookExistenceProtocol
    
    init( dataManager: BookExistenceProtocol = BookExistenceService.shared) {
        self.dataManager = dataManager
        
    }
    
    //MARK: server
    func getBookExistence() {
        dataManager.getBookExistence()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    print("--성공--")
                    print(self.result)
                    if let book = self.result.bookKey {
                        print("가계부 있음")
                        self.bookKey = book
                        Keychain.setKeychain(self.bookKey, forKey: .bookKey)
                        AuthenticationService.shared.bookStatus = true
                    } else {
                        print("가계부 없음")
                        AuthenticationService.shared.bookStatus = false
                    }

                }
            }.store(in: &cancellableSet)
    }
    

    func createAlert( with error: NetworkError) {
        loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
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
