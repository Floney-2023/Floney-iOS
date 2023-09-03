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
    func setBookCode() {
        Keychain.setKeychain(self.result.bookKey, forKey: .bookKey)
        Keychain.setKeychain(self.result.code, forKey: .bookCode)
    }
    
    func createAlert( with error: NetworkError) {
        createBookLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
