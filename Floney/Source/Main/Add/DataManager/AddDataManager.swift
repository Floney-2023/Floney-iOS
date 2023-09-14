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
    func postCategory(_ parameters:AddCategoryRequest) -> AnyPublisher<DataResponse<AddCategoryResponse, NetworkError>, Never>
    func deleteCategory(parameters: DeleteCategoryRequest) -> AnyPublisher<Void, NetworkError>
    func deleteLine(parameters: DeleteLineRequest) -> AnyPublisher<Void, NetworkError>
    func changeLine(parameters: ChangeLineRequest) -> AnyPublisher<DataResponse<LinesResponse, NetworkError>, Never>
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
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
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
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
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
    func postCategory(_ parameters:AddCategoryRequest) -> AnyPublisher<DataResponse<AddCategoryResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/categories"
        print("\(url)")
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: AddCategoryResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func deleteCategory(parameters: DeleteCategoryRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/categories"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        
        return AF.request(url,
                          method: .delete,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishData()
        .tryMap { result in
            // Check the status code
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return // Success, return
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
    func deleteLine(parameters: DeleteLineRequest) -> AnyPublisher<Void, NetworkError> {
        let bookLineKey = String(parameters.bookLineKey)
        let url = "\(Constant.BASE_URL)/books/lines/delete?bookLineKey=\(bookLineKey)"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        
        return AF.request(url,
                          method: .delete,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishData()
        .tryMap { result in
            // Check the status code
            if let statusCode = result.response?.statusCode {
                print("Status Code: \(statusCode)")
                if statusCode == 200 {
                    return // Success, return
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
    func changeLine(parameters:ChangeLineRequest) -> AnyPublisher<DataResponse<LinesResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/lines/change"
        print("\(url)")
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
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

}
