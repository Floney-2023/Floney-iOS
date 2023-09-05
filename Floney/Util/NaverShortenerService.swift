//
//  NaverShortenerService.swift
//  Floney
//
//  Created by 남경민 on 2023/09/05.
//

import Foundation
import Combine
import Alamofire

class NaverShortenerService {
    var cancellables: Set<AnyCancellable> = []

    let headers: HTTPHeaders = [
        "X-Naver-Client-Id": Secret.NAVER_CLIENT_ID,
        "X-Naver-Client-Secret": Secret.NAVER_CLIENT_SECRET
    ]

    func getShortenedURL(for url: String) -> AnyPublisher<DataResponse<NaverShortURLResponse, NetworkError>, Never> {
        let parameters: Parameters = ["url": url]

        return AF.request("https://openapi.naver.com/v1/util/shorturl", parameters: parameters, headers: headers)
            .publishDecodable(type: NaverShortURLResponse.self)
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

struct NaverShortURLResponse: Decodable {
    let result: NaverShortURLResult
}

struct NaverShortURLResult: Decodable {
    let url: String
}
