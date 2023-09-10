//
//  CreateBookViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
class CreateBookViewModel: ObservableObject {
    @Published var result : CreateBookResponse = CreateBookResponse(bookKey: "", code: "")
    @Published var bookInfo = BookInfoByCodeResponse(bookName: "", startDay: "", memberCount: 0)
    @Published var bookName = ""
    @Published var startDay = ""
    @Published var memberCount : String = ""
    @Published var bookImg : String?
    @Published var createBookLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var name : String = ""
    @Published var profileImg : String = ""
    @Published var isNextToCreateBook : Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: CreateBookProtocol
    
    init( dataManager: CreateBookProtocol = CreateBook.shared) {
        self.dataManager = dataManager
        //postSignIn()
    }
    
    func createBook() {
        let request = CreateBookRequest(name: name, profileImg: profileImg)
        dataManager.createBook(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.isNextToCreateBook = true
                    print(self.result) // bookkey & code
                    // bookKey는 request할 때 사용, code는 초대할 때 사용
                    print(self.result.code)
                }
            }.store(in: &cancellableSet)
    }

    func inviteBookCode() {
        if let inviteCode = AppLinkManager.shared.inviteCode {
            let request = InviteBookRequest(code: inviteCode)
            dataManager.inviteBook(request)
                .sink { (dataResponse) in
                    if dataResponse.error != nil {
                        self.createAlert(with: dataResponse.error!)
                        print(dataResponse.error)
                    } else {
                        self.result = dataResponse.value!
                        
                        print(self.result) // bookkey & code
                        // bookKey는 request할 때 사용, code는 초대할 때 사용
                        print(self.result.code)
                        self.setBookCode()
                        AppLinkManager.shared.inviteStatus = false
                        AppLinkManager.shared.hasDeepLink = false
                    }
                }.store(in: &cancellableSet)
        }
    }
    func bookInfoByCode() {
        if let inviteCode = AppLinkManager.shared.inviteCode {
            dataManager.bookInfoByCodeBook(bookCode: inviteCode)
                .sink { (dataResponse) in
                    if dataResponse.error != nil {
                        self.createAlert(with: dataResponse.error!)
                        print(dataResponse.error)
                    } else {
                        self.bookInfo = dataResponse.value!
                        print(self.bookInfo)
                        self.bookName = self.bookInfo.bookName
                        
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS" // 입력 문자열의 형식
                        if let date = inputFormatter.date(from: self.bookInfo.startDay) {
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "yyyy.MM.dd" // 원하는 출력 형식
                            
                            let resultString = outputFormatter.string(from: date)
                            self.startDay = resultString
                            print(resultString) // 출력: 2023.07.17
                        } else {
                            print("Invalid date string")
                        }
                        self.memberCount = String(self.bookInfo.memberCount)
                        if let img = self.bookInfo.bookImg {
                            self.bookInfo.bookImg = img
                        }
                    }
                }.store(in: &cancellableSet)
        }
    }
    func setBookCode() {
        Keychain.setKeychain(self.result.bookKey, forKey: .bookKey)
        Keychain.setKeychain(self.result.code, forKey: .bookCode)
    }
    
    func createAlert( with error: NetworkError) {
        createBookLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
