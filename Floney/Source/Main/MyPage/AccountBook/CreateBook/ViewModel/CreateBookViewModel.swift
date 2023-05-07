//
//  CreateBookViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
class CreateBookViewModel: ObservableObject {
    @Published var result : CreateBookResponse = CreateBookResponse(name: "", profileImg: "", seeProfile: -1, initialAsset: -1, bookKey: "", budget: -1, weekStartDay: "", carryOver: false, code: "")
    @Published var createBookLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var name : String = ""
    @Published var profileImg : String = ""
    
    
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
                    print(self.result.name)
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError) {
        createBookLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
