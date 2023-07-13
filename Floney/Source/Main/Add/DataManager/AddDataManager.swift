//
//  AddDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/20.
//

import Alamofire
import Combine

protocol AddProtocol {
    func getCategory(_ parameters:CategoryRequest) -> AnyPublisher<DataResponse<[CategoryResponse], NetworkError>, Never>
    func postLines(_ parameters:LinesRequest) -> AnyPublisher<DataResponse<LinesResponse, NetworkError>, Never>
    func postCategory(_ parameters:AddCategoryRequest) -> AnyPublisher<DataResponse<CategoryResponse, NetworkError>, Never>
}

class AddService {
    static let shared: AddProtocol = AddService()
    private init() { }
}

extension AddService: AddProtocol {
    func getCategory(_ parameters:CategoryRequest) -> AnyPublisher<DataResponse<[CategoryResponse], NetworkError>, Never> {
        let bookKey = parameters.bookKey
        let root = parameters.root
        let urlString = "\(Constant.BASE_URL)/books/categories?bookKey=\(bookKey)&root=\(root)"
        print("\(urlString)")
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedString!)!
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: [CategoryResponse].self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func postLines(_ parameters:LinesRequest) -> AnyPublisher<DataResponse<LinesResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/lines"
        print("\(url)")
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: LinesResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func postCategory(_ parameters:AddCategoryRequest) -> AnyPublisher<DataResponse<CategoryResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/categories"
        print("\(url)")
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: CategoryResponse.self)
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
