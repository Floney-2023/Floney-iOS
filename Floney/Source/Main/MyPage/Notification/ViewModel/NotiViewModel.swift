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
    @Published var result : MyPageResponse = MyPageResponse(nickname: "", email: "", profileImg: "", provider: "", lastAdTime: nil, myBooks: [])
    @Published var bookNotiList : [BookNoti] = [BookNoti(bookKey: "", bookName: "", notiList: [])]
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
                    self.myBooks.sort { $0.name < $1.name }
                    print(self.myBooks)
                    self.bookNotiList = []
                    // 모든 책에 대한 알림을 가져오고, 가져온 후에 bookNotiList 정렬
                    let dispatchGroup = DispatchGroup()
                    
                    for book in self.myBooks {
                        dispatchGroup.enter()
                        self.getNoti(bookKey: book.bookKey, bookName: book.name) {
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        self.sortBookNotiListByMyBooksOrder()
                    }
                    
                }
            }.store(in: &cancellableSet)
    }
    func sortBookNotiListByMyBooksOrder() {
        self.bookNotiList.sort { (first, second) -> Bool in
            guard let firstIndex = self.myBooks.firstIndex(where: { $0.bookKey == first.bookKey }),
                  let secondIndex = self.myBooks.firstIndex(where: { $0.bookKey == second.bookKey }) else {
                return false
            }
            return firstIndex < secondIndex
        }
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
    func getNoti(bookKey : String, bookName: String, completion: @escaping () -> Void) {
        dataManager.getNoti(bookKey: bookKey)
            .sink { (dataResponse) in
                
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.getNoti(bookKey: bookKey, bookName: bookName,completion: completion)
                    })
                    print(dataResponse.error)
                } else {
                    
                    if let notiList = dataResponse.value {
                        let updatedNotiList = notiList.map { noti -> NotiResponse in
                            var modifiedNoti = noti
                            if modifiedNoti.imgUrl == "icon_exit" {
                                modifiedNoti.imgUrl = "icon_noti_exit"
                            } else if modifiedNoti.imgUrl == "icon_join" {
                                modifiedNoti.imgUrl = "icon_noti_join"
                            } else if modifiedNoti.imgUrl == "noti_settlement" {
                                modifiedNoti.imgUrl = "icon_noti_settlement"
                            }
                            modifiedNoti.date = self.convertUTCDateToLocalDate(utcDateStr: noti.date)
                            return modifiedNoti
                        }
                        print("updated noti list : \(updatedNotiList)")
                        self.bookNotiList.append(
                            BookNoti(bookKey: bookKey, bookName: bookName, notiList: updatedNotiList)
                        )
                    
                        print(self.bookNotiList)
                    }
                    completion()
      
                }
            }.store(in: &cancellableSet)
    }

    func convertUTCDateToLocalDate(utcDateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // UTC 날짜 형식
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let utcDate = dateFormatter.date(from: utcDateStr) {
            dateFormatter.timeZone = TimeZone.current // 사용자의 현재 시간대로 변경
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // 변환할 날짜 형식
            return dateFormatter.string(from: utcDate)
        } else {
            return utcDateStr // 변환 실패 시 원래 문자열 반환
        }
    }

    
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            if error.backendError?.code != "U006" {
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
