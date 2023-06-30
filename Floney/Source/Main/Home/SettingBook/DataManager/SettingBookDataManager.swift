//
//  SettingBookDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation

import Alamofire
import Combine

protocol SettingBookProtocol {
    func getBookInfo(_ parameters:BookInfoRequest) -> AnyPublisher<DataResponse<BookInfoResponse, NetworkError>, Never>
    func changeProfile(parameters: BookProfileRequest) -> AnyPublisher<Void, NetworkError>
    func changeNickname(parameters: BookNameRequest) -> AnyPublisher<Void, NetworkError>
    func changeProfileStatus(parameters: SeeProfileRequest) -> AnyPublisher<Void, NetworkError>
    func setBudget(parameters: SetBudgetRequest) -> AnyPublisher<Void, NetworkError>
    func setAsset(parameters: SetAssetRequest) -> AnyPublisher<Void, NetworkError>
}

class SettingBookService {
    static let shared: SettingBookProtocol = SettingBookService()
    private init() { }
}

extension SettingBookService: SettingBookProtocol {
    func getBookInfo(_ parameters:BookInfoRequest) -> AnyPublisher<DataResponse<BookInfoResponse, NetworkError>, Never> {
    
        let bookKey = parameters.bookKey
        let url = "\(Constant.BASE_URL)/books/info?bookKey=\(bookKey)"
        print(url)
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: BookInfoResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    func changeProfile(parameters: BookProfileRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/bookImg"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("change profile : \n\(token)")
        
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
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
    
    
    func changeNickname(parameters: BookNameRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/name"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("change nickname : \n\(token)")
        
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
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
    func changeProfileStatus(parameters: SeeProfileRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/seeProfile"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("change nickname : \n\(token)")
        
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
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
    func setBudget(parameters: SetBudgetRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/budget"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("change budget : \n\(parameters.budget)")
        
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
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
    func setAsset(parameters: SetAssetRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/asset"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("set asset : \n\(parameters.asset)")
        
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
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


}

