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
        let url = "\(Constant.BASE_URL)/books/code"
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":token])
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
