//
//  SignInViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/01.
//

import Foundation
import Combine
class SignInViewModel: ObservableObject {
    
    @Published var chats =  [ChatModel]()
    @Published var chatListLoadingError: String = ""
    @Published var showAlert: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        getChatList()
    }
    
    func getChatList() {
        dataManager.fetchChats()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.chats = dataResponse.value!.chats
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
