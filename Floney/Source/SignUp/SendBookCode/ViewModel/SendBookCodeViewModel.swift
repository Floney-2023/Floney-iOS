//
//  SendBookCodeViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
class BookCodeViewModel: ObservableObject {
    @Published var result : BookCodeResponse = BookCodeResponse(name: "", profileImg: "", seeProfile: -1, initialAsset: -1, bookKey: "", budget: -1, weekStartDay: "", carryOver: false, code: "")
    @Published var bookCodeLoadingError: String = ""
    @Published var showAlert: Bool = false
    
    @Published var code : String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: BookCodeProtocol
    
    init( dataManager: BookCodeProtocol = BookCode.shared) {
        self.dataManager = dataManager
        //postSignIn()
    }
    
    func postBookCode() {
        let request = BookCodeRequest(code: code)
        dataManager.postBookCode(request)
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
        bookCodeLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
