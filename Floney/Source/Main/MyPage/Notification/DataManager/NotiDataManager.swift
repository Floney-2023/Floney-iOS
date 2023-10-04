//
//  NotiDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/10/03.
//

import Alamofire
import Combine

protocol NotiProtocol {
    func getNoti(bookKey : String) -> AnyPublisher<DataResponse<[NotiResponse], NetworkError>, Never>
    func postNoti(_ parameters:NotiRequest) -> AnyPublisher<Void, NetworkError>
    
}

class NotiService {
    static let shared: NotiProtocol = NotiService()
    private init() { }
}

extension NotiService: NotiProtocol {
    func getNoti(bookKey : String) -> AnyPublisher<DataResponse<[NotiResponse], NetworkError>, Never> {
        
        let url = "\(Constant.BASE_URL)/books/alarm?bookKey=\(bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""

        return  AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: [NotiResponse].self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    func postNoti(_ parameters:NotiRequest) -> AnyPublisher<Void, NetworkError>{
        
        let url = "\(Constant.BASE_URL)/books/alarm"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("알람 요청 : \(parameters)")
        return  AF.request(url,
                           method: .post,
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
    
}
