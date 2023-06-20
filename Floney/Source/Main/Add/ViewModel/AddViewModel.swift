//
//  AddViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Foundation
import Combine
class AddViewModel: ObservableObject {
    @Published var categoryResult : [CategoryResponse] = []
    @Published var categories : [String] = []
    @Published var addLoadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var bookKey = ""
    @Published var root = ""
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: AddProtocol
    
    init( dataManager: AddProtocol = AddService.shared) {
        self.dataManager = dataManager
    }
    
    //MARK: server
    func getCategory() {
        bookKey = "2FE56430"
        let request = CategoryRequest(bookKey: bookKey, root: root)
        dataManager.getCategory(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    // 에러 처리
                    print(dataResponse.error)
                } else {
                    self.categoryResult = dataResponse.value!
                    print("--성공--")
                    print(self.categoryResult)
                    DispatchQueue.main.async {
                        self.categories = []
                        for i in self.categoryResult {
                            self.categories.append(i.name)
                            print(i.name)
                        }
                        print(self.categories)
                    }
                    
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError) {
        addLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
        // 에러 처리
    }
}
