//
//  ManageRepeatLineViewModel.swift
//  Floney
//
//  Created by 남경민 on 3/6/24.
//

import Foundation
import Combine

class ManageRepeatLineViewModel : ObservableObject {
    var alertManager = AlertManager.shared
    @Published var tokenViewModel = TokenReissueViewModel()
    @Published var categoryType = ""
    @Published var repeatLineList : [RepeatLineResponse] = []
    @Published var isApiCalling: Bool = false
    @Published var successStatus: Bool = false
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ManageRepeatLineProtocol
    
    init(dataManager: ManageRepeatLineProtocol = ManageRepeatLineService.shared) {
        self.dataManager = dataManager
    }
    
    func getRepeatLine() {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = RepeatLineRequest(bookKey: bookKey, categoryType: categoryType)
        dataManager.getRepeatLine(request)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getRepeatLine()
                    })
                } else {
                    self.repeatLineList = dataResponse.value!
                    for index in self.repeatLineList.indices {
                        var line = self.repeatLineList[index]
                        if let durationType = RepeatDurationType(rawValue: line.repeatDuration) {
                            self.repeatLineList[index].repeatDurationDescription = durationType.description()
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func deleteRepeatLine(repeatLineId: Int) {
        guard !isApiCalling else { return }
        isApiCalling = true
        let request = DeleteRepeatLineRequest(repeatLineId: repeatLineId)
        dataManager.deleteRepeatLine(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isApiCalling = false
                    self.successStatus = true
                    self.alertManager.update(showAlert: true, message: "삭제가 완료되었습니다.", buttonType: .green)
                    print("반복 내역 삭제 성공")
                    self.getRepeatLine()
                case .failure(let error):
                    print(error)
                    self.isApiCalling = false
                    self.createAlert(with: error, retryRequest: {
                        self.deleteRepeatLine(repeatLineId: repeatLineId)
                    })
                }
            } receiveValue: { data in
                
            }
            .store(in: &cancellableSet)
    }
    
    func deleteAllRepeatLine(bookLineKey: Int) {
        guard !isApiCalling else { return }
        isApiCalling = true
        let request = DeleteAllRepeatLineRequest(bookLineKey: bookLineKey)
        dataManager.deleteAllRepeatLine(parameters: request)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isApiCalling = false
                    self.successStatus = true
                    self.alertManager.update(showAlert: true, message: "삭제가 완료되었습니다.", buttonType: .green)
                    print("반복 내역 모두 삭제 성공")
                case .failure(let error):
                    print(error)
                    self.isApiCalling = false
                    self.createAlert(with: error, retryRequest: {
                        self.deleteAllRepeatLine(bookLineKey: bookLineKey)
                    })
                }
            } receiveValue: { data in
                
            }
            .store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            if error.backendError?.code != "U006" && error.backendError?.code != "B001"{
                AlertManager.shared.handleError(serverError)
            }
            // 에러코드에 따른 추가 로직
            if let errorCode = error.backendError?.code {
                switch errorCode {
                    // 토큰 재발급
                case "U006" :
                    tokenViewModel.tokenReissue {
                        // 토큰 재발급 성공 시, 원래의 요청 재시도
                        retryRequest()
                    }
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
