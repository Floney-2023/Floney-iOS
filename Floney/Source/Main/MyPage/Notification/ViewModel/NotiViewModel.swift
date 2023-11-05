//
//  NotiViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/10/03.
//

import Foundation

import Foundation
import Combine
import SwiftUI

final class NotiViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var result : MyPageResponse = MyPageResponse(nickname: "", email: "", profileImg: "", provider: "", subscribe: false, lastAdTime: nil, myBooks: [])
    @Published var bookNotiList : [BookNoti] = []
    @Published var myBooks : [MyBookResult] = []
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: NotiProtocol
    
    init( dataManager: NotiProtocol = NotiService.shared) {
        self.dataManager = dataManager
    }
    
    func getMyPage() {
        dataManager.getMyPage()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getMyPage()
                    })
                    print(dataResponse.error)
                } else {
                    self.result = dataResponse.value!
                    self.myBooks = self.result.myBooks!
                    self.bookNotiList = []
                    for book in self.myBooks {
                        self.getNoti(bookKey: book.bookKey, bookName: book.name)
                    }
                    print("get my page in : \(self.bookNotiList)")
                }
            }.store(in: &cancellableSet)
    }
    
    func postNoti(title :String, body: String, imgUrl : String, userEmail : String, date : String) {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let request = NotiRequest(bookKey: bookKey, title: title, body: body, imgUrl: imgUrl, userEmail: userEmail, date: date)
        dataManager.postNoti(request)
            .sink { completion in

                switch completion {
                case .finished:
                    print("postNoti success.")
                case .failure(let error):
                    self.createAlert(with: error, retryRequest: {
                        self.postNoti(title: title, body: body, imgUrl: imgUrl, userEmail: userEmail, date: date)
                    })
                    print("Error posting noti: \(error)")
                }
            } receiveValue: { data in
                // TODO: Handle the received data if necessary.
            }
            .store(in: &cancellableSet)
    }
    func getNoti(bookKey : String, bookName: String) {
        dataManager.getNoti(bookKey: bookKey)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getNoti(bookKey: bookKey, bookName: bookName)
                    })
                    print(dataResponse.error)
                } else {
                    self.bookNotiList.append(
                        BookNoti(bookKey: bookKey, bookName: bookName, notiList: dataResponse.value!)
                    )
                    print(self.bookNotiList)
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
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
