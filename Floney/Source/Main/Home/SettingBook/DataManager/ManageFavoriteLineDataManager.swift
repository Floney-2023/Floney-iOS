//
//  ManageFavoriteLineDataManager.swift
//  Floney
//
//  Created by 남경민 on 5/21/24.
//

import Alamofire
import Combine

protocol ManageFavoriteLineProtocol {
    func getFavoriteLine(_ parameters:FavoriteLineRequest) -> AnyPublisher<DataResponse<[FavoriteLineResponse], NetworkError>, Never>
    func addFavoriteLine(_ parameters:AddFavoriteLineRequest, bookKey: String) -> AnyPublisher<DataResponse<FavoriteLineResponse, NetworkError>, Never>
}

class ManageFavoriteLineService {
    static let shared: ManageFavoriteLineProtocol = ManageFavoriteLineService()
    private init() { }
}

extension ManageFavoriteLineService: ManageFavoriteLineProtocol {
    func getFavoriteLine(_ parameters: FavoriteLineRequest) -> AnyPublisher<Alamofire.DataResponse<[FavoriteLineResponse], NetworkError>, Never> {
        let bookKey = parameters.bookKey
        let categoryType = parameters.categoryType
        let url = "\(Constant.BASE_URL)/books/\(bookKey)/favorites?categoryType=\(categoryType)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: [FavoriteLineResponse].self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func addFavoriteLine(_ parameters:AddFavoriteLineRequest, bookKey: String) -> AnyPublisher<DataResponse<FavoriteLineResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/\(bookKey)/favorites"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: FavoriteLineResponse.self)
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
