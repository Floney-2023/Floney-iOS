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
    func changeProfile(img: String?) -> AnyPublisher<Void, NetworkError>
    func changeNickname(nickname: String) -> AnyPublisher<Void, NetworkError>
    func logout() -> AnyPublisher<Void, NetworkError>
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
    
    func changeProfile(img: String?) -> AnyPublisher<Void, NetworkError> {
        var url = ""
        if let imageUrl = img {
            url = "\(Constant.BASE_URL)/users/profileimg/update?profileImg=\(imageUrl)"
        } else {
            url = "\(Constant.BASE_URL)/users/profileimg/update?profileImg="
        }
        
        
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("My Page : \n\(token)")
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishData()
        .tryMap { result in
            // Check the status code
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return // Success, return
                } else {
                    // Handle error based on status code
                    let backendError = result.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}

                    
                    if let backendError = backendError {
                        throw NetworkError(initialError: result.error!, backendError: backendError)
                    } else {
                        throw NetworkError(initialError: result.error!, backendError: nil)
                    }
                }
            } else {
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
        }
        .mapError { error in
            return error as! NetworkError
        }
        .eraseToAnyPublisher()
    }

    func changeNickname(nickname: String) -> AnyPublisher<Void, NetworkError> {
        let urlString = "\(Constant.BASE_URL)/users/nickname/update?nickname=\(nickname)"
        print("\(urlString)")
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedString!)!
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("change nickname : \n\(token)")
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishData()
        .tryMap { result in
            // Check the status code
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return // Success, return
                } else {
                    // Handle error based on status code
                    let backendError = result.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}

                    
                    if let backendError = backendError {
                        throw NetworkError(initialError: result.error!, backendError: backendError)
                    } else {
                        throw NetworkError(initialError: result.error!, backendError: nil)
                    }
                }
            } else {
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
        }
        .mapError { error in
            return error as! NetworkError
        }
        .eraseToAnyPublisher()
        
    }
    func logout() -> AnyPublisher<Void, NetworkError> {

        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        let url = "\(Constant.BASE_URL)/users/logout?accessToken=\(token)"
        print("change nickname : \n\(token)")
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default
                          )
        .validate()
        .publishData()
        .tryMap { result in
            // Check the status code
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return // Success, return
                } else {
                    // Handle error based on status code
                    let backendError = result.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}

                    
                    if let backendError = backendError {
                        throw NetworkError(initialError: result.error!, backendError: backendError)
                    } else {
                        throw NetworkError(initialError: result.error!, backendError: nil)
                    }
                }
            } else {
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
        }
        .mapError { error in
            return error as! NetworkError
        }
        .eraseToAnyPublisher()
        
    }

}
