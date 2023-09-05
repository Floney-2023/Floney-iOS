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
    func getShortenedURL(for url: String) -> AnyPublisher<DataResponse<NaverShortURLResponse, NetworkError>, Never> {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "X-Naver-Client-Id": Secret.NAVER_CLIENT_ID,
            "X-Naver-Client-Secret": Secret.NAVER_CLIENT_SECRET
        ]
        let parameters = NaverRequest(url: url)
        
        return AF.request("https://openapi.naver.com/v1/util/shorturl",
                          method: .post,
                          parameters: parameters,
                          encoder: URLEncodedFormParameterEncoder(),
                          headers: headers)
            .validate()
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
struct NaverRequest : Encodable {
    let url : String
}

struct NaverShortURLResponse: Decodable {
    let result: NaverShortURLResult
}


struct NaverShortURLResult: Decodable {
    let url: String
    let orgUrl : String
}
