//
//  MyPageDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation
import Combine
import Alamofire

protocol MyPageProtocol {
    func getMyPage() -> AnyPublisher<DataResponse<MyPageResponse, NetworkError>, Never>
}


class MyPage {
    static let shared: MyPageProtocol = MyPage()
    private init() { }
}

extension MyPage: MyPageProtocol {
    func getMyPage() -> AnyPublisher<DataResponse<MyPageResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/users/mypage"
        //let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJydWRhbHN3aGRrMTJAbmF2ZXIuY29tIiwiaWF0IjoxNjg3MDY2MTU1LCJleHAiOjE2ODcwNjk3NTV9.-CCO-ChO7Olw3z3hu9dcbjxq4IbfGWQupVdI0FEYdTk"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("My Page : \n\(token)")
       /*
        guard let token = Keychain.getKeychainValue(forKey: .accessToken) else {
            // 토큰 재발급 로직
            return
        }
        */
        //let token = Keychain.getKeychainValue(forKey: .authorization)
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: MyPageResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
