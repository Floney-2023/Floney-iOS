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
}

class AnalysisService {
    static let shared: AnalysisProtocol = AnalysisService()
    private init() { }
}

extension AnalysisService: AnalysisProtocol {
    func analysisExpenseIncome(_ parameters: ExpenseIncomeRequest) -> AnyPublisher<Alamofire.DataResponse<ExpenseIncomeResponse, NetworkError>, Never> {
        let bookKey = parameters.bookKey
        let root = parameters.root
        let urlString = "\(Constant.BASE_URL)/books/anayze/category?bookKey=\(bookKey)&root=\(root)"
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
