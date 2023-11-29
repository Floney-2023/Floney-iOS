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
    // 사용자 입장 시 save token
    func saveToken(for userId: String, bookKey: String, token: String) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookKey)
        let userRef = bookRef.collection("users").document(userId)
        userRef.setData(["fcmToken": token], merge: true)
    }
    func deleteBookTokens(bookKey : String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookKey)
        // 컬렉션의 모든 문서 가져오기
        bookRef.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            // 각 문서 삭제
            for document in snapshot!.documents {
                document.reference.delete()
            }
        }

        bookRef.delete() { error in
            if let error = error {
                print("Error removing book's all tokens: \(error.localizedDescription)")
            } else {
                print("Book successfully removed")
            }
        }
        completion()
    }
    
    func deleteUserToken(bookKey: String, email: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let bookRef = db.collection("books").document(bookKey)
        let userDocRef = bookRef.collection("users").document(email)

        userDocRef.delete() { error in
            if let error = error {
                print("Error removing user token : \(error.localizedDescription)")
            } else {
                print("User successfully removed")
            }
        }
        completion()
    }

    // fetchTokens : 해당 가계부의 멤버의 토큰들 가져오기
    func fetchTokensFromDatabase(bookKey : String, title : String, body : String, completion: @escaping () -> Void){
        fetchAccessToken()
            .sink { dataResponse in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.fetchTokensFromDatabase(bookKey: bookKey, title: title, body: body, completion: completion)
                    })
                    print(dataResponse.error)
                    
                } else {
                    print("fcm access token 요청 성공")
                    self.fcmAccessToken = dataResponse.value!.token
                    
                    let db = Firestore.firestore()
                    let bookRef = db.collection("books").document(bookKey)
                    let usersCollection = bookRef.collection("users")
                    print("In Fetch Tokens From DB book:\(bookRef)")
                    print("In Fetch Tokens From DB user collection:\(usersCollection)")
                    
                    usersCollection.getDocuments { (snapshot, error) in
                        guard let documents = snapshot?.documents else {
                            print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }
                        for document in documents {
                            if let fcmToken = document.data()["fcmToken"] as? String {
                                let myToken = Keychain.getKeychainValue(forKey: .fcmToken) ?? ""
                                if fcmToken == myToken { continue }
                                print("In Fetch Tokens From DB token:\(fcmToken)")
                                self.sendFCMNotification(to: fcmToken, title: title, body: body)
                            }
                        }
                    }
                    completion()
                }
            }.store(in: &cancellableSet)
    }
    // firebase에 노티 요청
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
