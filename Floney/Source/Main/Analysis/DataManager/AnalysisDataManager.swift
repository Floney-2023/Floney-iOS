//
//  AnalysisDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import Alamofire
import Combine

protocol AnalysisProtocol {
    func analysisExpenseIncome(_ parameters:ExpenseIncomeRequest) -> AnyPublisher<DataResponse<ExpenseIncomeResponse, NetworkError>, Never>
    func analysisBudget(_ parameters:BudgetAssetRequest) -> AnyPublisher<DataResponse<BudgetResponse, NetworkError>, Never>
    func analysisAsset(_ parameters:BudgetAssetRequest) -> AnyPublisher<DataResponse<AssetResponse, NetworkError>, Never>
}

class AnalysisService {
    static let shared: AnalysisProtocol = AnalysisService()
    private init() { }
}

extension AnalysisService: AnalysisProtocol {
    func analysisAsset(_ parameters: BudgetAssetRequest) -> AnyPublisher<Alamofire.DataResponse<AssetResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/analyze/asset"
        print("\(url)")
      
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: AssetResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func analysisBudget(_ parameters: BudgetAssetRequest) -> AnyPublisher<Alamofire.DataResponse<BudgetResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/analyze/budget"
        print("\(url)")
      
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: BudgetResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }


    func analysisExpenseIncome(_ parameters: ExpenseIncomeRequest) -> AnyPublisher<Alamofire.DataResponse<ExpenseIncomeResponse, NetworkError>, Never> {
      
        let url = "\(Constant.BASE_URL)/analyze/category"
        print("\(url)")
      
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: ExpenseIncomeResponse.self)
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
