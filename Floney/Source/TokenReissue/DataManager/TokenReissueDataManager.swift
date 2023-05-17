//
//  TokenReissueDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/05/17.
//

import Foundation
import Alamofire
import Combine

protocol TokenReissueProtocol {
    func tokenReissue(_ parameters:TokenReissueRequest) -> AnyPublisher<DataResponse<TokenReissueResponse, NetworkError>, Never>
}


class TokenReissue {
    static let shared: TokenReissueProtocol = TokenReissue()
    private init() { }
}

extension TokenReissue: TokenReissueProtocol {
    func tokenReissue(_ parameters:TokenReissueRequest) -> AnyPublisher<DataResponse<TokenReissueResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/users/reissue"
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder())
        .validate()
        .publishDecodable(type: TokenReissueResponse.self)
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
