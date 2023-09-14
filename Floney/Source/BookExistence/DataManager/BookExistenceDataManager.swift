//
//  BookExistenceDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/07/17.
//

import Alamofire
import Combine

protocol BookExistenceProtocol {
    func getBookExistence() -> AnyPublisher<DataResponse<BookExistenceResponse, NetworkError>, Never>

}

class BookExistenceService {
    static let shared: BookExistenceProtocol = BookExistenceService()
    private init() { }
}

extension BookExistenceService: BookExistenceProtocol {
    func getBookExistence() -> AnyPublisher<DataResponse<BookExistenceResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/users/check"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("book existence manager Token : \(token)")
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: BookExistenceResponse.self)
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
