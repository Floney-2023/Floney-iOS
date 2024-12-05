//
//  SubscriptionDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/13.
//

import Alamofire
import Combine

protocol SubscriptionProtocol {
    func getSubscriptionInfo() -> AnyPublisher<DataResponse<IAPInfoResponse, NetworkError>, Never>
    func postTransactionId(id: Int) -> AnyPublisher<DataResponse<TransactionResponse, NetworkError>, Never>
}

class SubscriptionService {
    static let shared: SubscriptionProtocol = SubscriptionService()
    private init() { }
}

extension SubscriptionService: SubscriptionProtocol {
    func postTransactionId(id: Int) -> AnyPublisher<Alamofire.DataResponse<TransactionResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/subscribe/apple/transaction?transactionId=\(id)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "Bearer \(token)"])
        .validate()
        .publishDecodable(type: TransactionResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getSubscriptionInfo() -> AnyPublisher<DataResponse<IAPInfoResponse, NetworkError>, Never> {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey) ?? ""
        let url = "\(Constant.BASE_URL)/users/subscribe?bookKey=\(bookKey)"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print(url)
        print(token)
        return AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "Bearer \(token)"])
        .validate()
        .publishDecodable(type: IAPInfoResponse.self)
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
