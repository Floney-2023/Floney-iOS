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
    func postSettlements(_ parameters:AddSettlementRequest) -> AnyPublisher<DataResponse<AddSettlementResponse, NetworkError>, Never>
    func getSettlementList() -> AnyPublisher<DataResponse<[SettlementListResponse], NetworkError>, Never>
    func getSettlementDetail(id : Int) -> AnyPublisher<DataResponse<AddSettlementResponse, NetworkError>, Never>
}

class CalculateService {
    static let shared: CalculateProtocol = CalculateService()
    private init() { }
}
/*
 AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: ["Authorization":"Bearer \(token)"])
 */

extension CalculateService: CalculateProtocol {
    func getSettlements(_ parameters:SettlementRequest) -> AnyPublisher<DataResponse<[SettlementResponse], NetworkError>, Never> {
        
        let url = "\(Constant.BASE_URL)/books/outcomes"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print(url)
        print(parameters)
        let parameters: Parameters = [
            "usersEmails": parameters.usersEmails,
            "dates": [
                "startDate": parameters.dates.startDate,
                "endDate": parameters.dates.endDate
            ]
        ]
        print("파라미터 \(parameters)")
        var request = URLRequest(url: try! url.asURL())
        request.headers = ["Authorization":"Bearer \(token)"]
        request.httpMethod = "GET"
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return AF.request(request)
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
    func postSettlements(_ parameters:AddSettlementRequest) -> AnyPublisher<DataResponse<AddSettlementResponse, NetworkError>, Never> {
        
        let url = "\(Constant.BASE_URL)/settlement"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print("정산 요청 : \(parameters)")
        return  AF.request(url,
                           method: .post,
                           parameters: parameters,
                           encoder: JSONParameterEncoder(),
                           headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: AddSettlementResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func getSettlementList() -> AnyPublisher<DataResponse<[SettlementListResponse], NetworkError>, Never> {
        let bookKey = Keychain.getKeychainValue(forKey: .bookKey)!
        let url = "\(Constant.BASE_URL)/settlement?bookKey=\(bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        
        return  AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: [SettlementListResponse].self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getSettlementDetail(id : Int) -> AnyPublisher<DataResponse<AddSettlementResponse, NetworkError>, Never> {
        
        let url = "\(Constant.BASE_URL)/settlement/\(id)"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print(url)
        
        return  AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: JSONEncoding.default,
                           headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: AddSettlementResponse.self)
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
