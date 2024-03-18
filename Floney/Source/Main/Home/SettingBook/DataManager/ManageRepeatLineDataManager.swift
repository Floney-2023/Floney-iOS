//
//  ManageRepeatLineDataManager.swift
//  Floney
//
//  Created by 남경민 on 3/6/24.
//

import Alamofire
import Combine

protocol ManageRepeatLineProtocol {
    func getRepeatLine(_ parameters:RepeatLineRequest) -> AnyPublisher<DataResponse<[RepeatLineResponse], NetworkError>, Never>
    func deleteRepeatLine(parameters: DeleteRepeatLineRequest) -> AnyPublisher<Void, NetworkError>
    func deleteAllRepeatLine(parameters: DeleteAllRepeatLineRequest) -> AnyPublisher<Void, NetworkError>
}

class ManageRepeatLineService {
    static let shared: ManageRepeatLineProtocol = ManageRepeatLineService()
    private init() { }
}

extension ManageRepeatLineService: ManageRepeatLineProtocol {
    func getRepeatLine(_ parameters: RepeatLineRequest) -> AnyPublisher<Alamofire.DataResponse<[RepeatLineResponse], NetworkError>, Never> {
        let bookKey = parameters.bookKey
        let categoryType = parameters.categoryType
        let url = "\(Constant.BASE_URL)/books/repeat?bookKey=\(bookKey)&categoryType=\(categoryType)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: [RepeatLineResponse].self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func deleteRepeatLine(parameters: DeleteRepeatLineRequest) -> AnyPublisher<Void, NetworkError> {
        let repeatLineId = parameters.repeatLineId
        let url = "\(Constant.BASE_URL)/books/repeat?repeatLineId=\(repeatLineId)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .delete,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishData()
        .tryMap { result in
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return
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
    
    func deleteAllRepeatLine(parameters: DeleteAllRepeatLineRequest) -> AnyPublisher<Void, NetworkError> {
        let bookLineKey = parameters.bookLineKey
        let url = "\(Constant.BASE_URL)/books/lines/all?bookLineKey=\(bookLineKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .delete,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishData()
        .tryMap { result in
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return
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
