//
//  FCMDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/02.
//

import Foundation
import FirebaseFirestore
import Alamofire
import Combine

class FCMDataManager: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var fcmAccessToken = ""
    private var cancellableSet: Set<AnyCancellable> = []
    init() {
        // 객체 생성 시 바로 관리자 accessToken 받아오기
    }
    func saveToken(for userId: String, bookKey: String, token: String) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookKey)
        let userRef = bookRef.collection("users").document(userId)
        
        userRef.setData(["fcmToken": token], merge: true)
    }
    func sendNotification(to bookKey: String, title: String, body: String) {
        callFetchAccessToken(bookKey: bookKey, title: title, body: body)
        print("send noti")
    }
    
    func fetchTokensFromDatabase(bookKey : String) -> [String]{
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookKey)
        let usersCollection = bookRef.collection("users")
        var fcmTokens : [String] = []
        
        usersCollection.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            for document in documents {
                if let fcmToken = document.data()["fcmToken"] as? String {
                    fcmTokens.append(fcmToken)
                }
            }
        }
        return fcmTokens
    }

    func sendFCMNotification(to token: String, title: String, body: String) {
        let url = "https://fcm.googleapis.com/v1/projects/floney/messages:send"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(fcmAccessToken)",
            "Content-Type": "application/json"
        ]
        print("fcm access token : \(fcmAccessToken)")
        print("fcm token : \(token)")
        
        let parameters = FCMRequest(message: FCMMessage(token: token, notification: FCMNotification(title: title, body: body)))
        print("parameters : \(parameters)")
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: headers).response { response in
            switch response.result {
            case .success(let value):
                print("Notification sent successfully: \(value)")
            case .failure(let error):
                print("Error sending notification: \(error.localizedDescription)")
            }
        }
    }
    
    func callFetchAccessToken(bookKey : String, title : String, body : String) {
        fetchAccessToken()
            .sink { dataResponse in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.callFetchAccessToken(bookKey: bookKey, title: title, body: body)
                    })
                    print(dataResponse.error)
                    
                } else {
                    print("fcm access token 요청 성공")
                    self.fcmAccessToken = dataResponse.value!.token
                    print(self.fcmAccessToken)
                    if let currentUserToken = Keychain.getKeychainValue(forKey: .fcmToken) {
                        // 1. 데이터베이스에서 모든 사용자의 FCM 토큰을 가져옵니다.
                        let tokens = self.fetchTokensFromDatabase(bookKey: bookKey)
                        
                        // 2. 현재 사용자의 토큰을 제거합니다.
                        let filteredTokens = tokens.filter { $0 != currentUserToken }
                        print("필터링된 토큰들 \(filteredTokens)")
                        // 3. 필터링된 토큰 목록을 사용하여 FCM 알림을 보냅니다.
                        for token in filteredTokens {
                            
                            self.sendFCMNotification(to: token, title: title, body: body)
                        }
                    }

                }
            }.store(in: &cancellableSet)
    }
    
    // server에 요청하기
    func fetchAccessToken() -> AnyPublisher<DataResponse<FCMAccessToken, NetworkError>,Never> {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let url = "\(Constant.BASE_URL)/google/alarm/tokens"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print(url)
        print(token)
        return AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "Bearer \(token)"])
        .validate()
        .publishDecodable(type: FCMAccessToken.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
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
