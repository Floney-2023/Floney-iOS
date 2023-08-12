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
    func changeProfile(img: String) -> AnyPublisher<Void, NetworkError>
    func changeNickname(nickname: String) -> AnyPublisher<Void, NetworkError>
    func changePassword(password: String) -> AnyPublisher<Void, NetworkError>
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
    
    func changeProfile(img: String) -> AnyPublisher<Void, NetworkError> {
        var url = "\(Constant.BASE_URL)/users/profileimg/update"

        print("My Page DataManager Change User Image \(url)")
        
        var parameters = [String: String]()
      
        parameters["profileImg"] = img
        
        print("parameters : \(parameters)")
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        //print("My Page : \n\(token)")
        
        return AF.request(url,
                          method: .get,
                          parameters: parameters,
                          encoding: CustomURLEncoding(),
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
    func changePassword(password: String) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/users/password/update?password=\(password)"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("change password : \n\(token)\n url: \(url)")
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
struct CustomURLEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        if let parameters = parameters {
            let urlString = request.url?.absoluteString.appending("?" + parameters.stringFromHttpParameters())
            request.url = URL(string: urlString!)
        }
        
        return request
    }
}

extension Dictionary {
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { key, value -> String in
            let percentEscapedKey = (key as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let percentEscapedValue = (value as! String).addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "+").inverted)!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
}
