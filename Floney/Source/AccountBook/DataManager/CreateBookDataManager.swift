//
//  CreateBookDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
import Alamofire

protocol CreateBookProtocol {
    func createBook(_ parameters:CreateBookRequest) -> AnyPublisher<DataResponse<CreateBookResponse, NetworkError>, Never>
    func inviteBook(_ parameters:InviteBookRequest) -> AnyPublisher<DataResponse<CreateBookResponse, NetworkError>, Never>
    func bookInfoByCodeBook(bookCode : String) -> AnyPublisher<DataResponse<BookInfoByCodeResponse, NetworkError>, Never>
}


class CreateBook {
    static let shared: CreateBookProtocol = CreateBook()
    private init() { }
}

extension CreateBook: CreateBookProtocol {
    func bookInfoByCodeBook(bookCode: String) -> AnyPublisher<Alamofire.DataResponse<BookInfoByCodeResponse, NetworkError>, Never> {
 
        let url = "\(Constant.BASE_URL)/books?code=\(bookCode)"
        let token = Keychain.getKeychainValue(forKey: .accessToken)
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token!)"])
            .validate()
            .publishDecodable(type: BookInfoByCodeResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createBook(_ parameters:CreateBookRequest) -> AnyPublisher<DataResponse<CreateBookResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books"
        //let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0QGVtYWlsLmNvbSIsImlhdCI6MTY4MzQ3NDUwOSwiZXhwIjoxNjgzNDc2MzA5fQ.s5mERqChJ3XU9vS1I1tx_rFmrU1hg1-JRj5OKJsDOGc"
        //let token = Common.getKeychainValue(forKey: .authorization)
       /*
        guard let token = Common.getKeychainValue(forKey: .authorization) else {
            // 토큰 재발급 로직
            return
        }
        */
        let token = Keychain.getKeychainValue(forKey: .accessToken)
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token!)"])
            .validate()
            .publishDecodable(type: CreateBookResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func inviteBook(_ parameters:InviteBookRequest) -> AnyPublisher<DataResponse<CreateBookResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/join"
        let token = Keychain.getKeychainValue(forKey: .accessToken)
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token!)"])
            .validate()
            .publishDecodable(type: CreateBookResponse.self)
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
