//
//  CalculateDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/07/10.
//


import Alamofire
import Combine

protocol CalculateProtocol {
    func getSettlements(_ parameters:SettlementRequest) -> AnyPublisher<DataResponse<[SettlementResponse], NetworkError>, Never>
}

class CalculateService {
    static let shared: CalculateProtocol = CalculateService()
    private init() { }
}

extension CalculateService: CalculateProtocol {
    func getSettlements(_ parameters:SettlementRequest) -> AnyPublisher<DataResponse<[SettlementResponse], NetworkError>, Never> {
        
        let url = "\(Constant.BASE_URL)/books/settlements"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        
        return AF.request(url,
                          method: .get,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: [SettlementResponse].self)
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
