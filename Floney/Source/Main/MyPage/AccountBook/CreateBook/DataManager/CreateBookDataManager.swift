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
}


class CreateBook {
    static let shared: CreateBookProtocol = CreateBook()
    private init() { }
}

extension CreateBook: CreateBookProtocol {
    func createBook(_ parameters:CreateBookRequest) -> AnyPublisher<DataResponse<CreateBookResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books"
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0QGVtYWlsLmNvbSIsImlhdCI6MTY4MzQ3NDUwOSwiZXhwIjoxNjgzNDc2MzA5fQ.s5mERqChJ3XU9vS1I1tx_rFmrU1hg1-JRj5OKJsDOGc"
        //let token = Common.getKeychainValue(forKey: .authorization)
       /*
        guard let token = Common.getKeychainValue(forKey: .authorization) else {
            // 토큰 재발급 로직
            return
        }
        */
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":token])
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
