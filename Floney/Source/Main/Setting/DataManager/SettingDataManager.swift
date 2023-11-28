//
//  SettingDataManager.swift
//  Floney
//
//  Created by 남경민 on 11/28/23.
//
import Alamofire
import Combine

protocol SettingProtocol {
    func postMarketing(_ parameters:MarketingRequest) -> AnyPublisher<Void, NetworkError>
    func getMarketing() -> AnyPublisher<DataResponse<MarketingResponse, NetworkError>, Never>
}

class Setting {
    static let shared: SettingProtocol = Setting()
    private init() { }
}

extension Setting: SettingProtocol {
    func getMarketing() -> AnyPublisher<Alamofire.DataResponse<MarketingResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/users/receive-marketing"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: MarketingResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    func postMarketing(_ parameters:MarketingRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/users/receive-marketing?agree=\(parameters.agree)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print(parameters)
        return AF.request(url,
                          method: .put,
                          parameters: nil,
                          encoding: JSONEncoding.default,
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
