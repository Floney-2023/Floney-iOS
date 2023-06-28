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
    func changeProfile(img: String) -> AnyPublisher<Data, NetworkError>
}


class MyPage {
    static let shared: MyPageProtocol = MyPage()
    private init() { }
}

extension MyPage: MyPageProtocol {
    func getMyPage() -> AnyPublisher<DataResponse<MyPageResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/users/mypage"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("My Page : \n\(token)")
      
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
    
    func changeProfile(img: String) -> AnyPublisher<Data, NetworkError> {
            let url = "\(Constant.BASE_URL)/users/profileimg/update?profileImg=\(img)"
            
            let token = Keychain.getKeychainValue(forKey: .accessToken)!
            print("My Page : \n\(token)")
          
        return AF.request(url,
                              method: .get,
                              parameters: nil,
                              encoding: JSONEncoding.default,
                              headers: ["Authorization":"Bearer \(token)"])
                .validate()
                .publishData()
                .tryMap { dataResponse in
                    guard let data = dataResponse.data else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                }
                .mapError { error in
                    let backendError = (error as? AFError)?.underlyingError.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0 as! Data)}
                    return NetworkError(initialError: error as! AFError, backendError: backendError)
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}
