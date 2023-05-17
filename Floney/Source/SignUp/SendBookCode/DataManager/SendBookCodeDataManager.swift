//
//  SendBookCodeDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//

import Foundation
import Combine
import Alamofire

protocol BookCodeProtocol {
    func postBookCode(_ parameters:BookCodeRequest) -> AnyPublisher<DataResponse<BookCodeResponse, NetworkError>, Never>
}


class BookCode {
    static let shared: BookCodeProtocol = BookCode()
    private init() { }
}

extension BookCode: BookCodeProtocol {
    func postBookCode(_ parameters:BookCodeRequest) -> AnyPublisher<DataResponse<BookCodeResponse, NetworkError>, Never> {
        let code = parameters.code
        let url = "\(Constant.BASE_URL)/books/join?code=\(code)"
        //let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0QGVtYWlsLmNvbSIsImlhdCI6MTY4MzQ3NDUwOSwiZXhwIjoxNjgzNDc2MzA5fQ.s5mERqChJ3XU9vS1I1tx_rFmrU1hg1-JRj5OKJsDOGc"
        let token = Keychain.getKeychainValue(forKey: .accessToken)
       /*
        guard let token = Common.getKeychainValue(forKey: .authorization) else {
            // 토큰 재발급 로직
            return
        }
        */
        //a7f35ca7

        return AF.request(url,
                          method: .post,
                          parameters: nil,
                          encoding:JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token!)"])
            .validate()
            .publishDecodable(type: BookCodeResponse.self)
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
