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
    func deleteFavoriteLine(parameters: DeleteFavoriteLineRequest) -> AnyPublisher<Void, NetworkError>
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
    
    func deleteFavoriteLine(parameters: DeleteFavoriteLineRequest) -> AnyPublisher<Void, NetworkError> {
        let favoriteId = parameters.favoriteId
        let url = "\(Constant.BASE_URL)/books/\(parameters.bookKey)/favorites/\(favoriteId)"
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
                if statusCode == 204 {
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
