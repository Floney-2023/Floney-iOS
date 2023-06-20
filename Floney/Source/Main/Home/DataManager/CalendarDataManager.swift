//
//  CalendarDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Alamofire
import Combine

protocol CalendarProtocol {
    func getCalendar(_ parameters:CalendarRequest) -> AnyPublisher<DataResponse<CalendarResponse, NetworkError>, Never>
}

class CalendarService {
    static let shared: CalendarProtocol = CalendarService()
    private init() { }
}

extension CalendarService: CalendarProtocol {
    func getCalendar(_ parameters:CalendarRequest) -> AnyPublisher<DataResponse<CalendarResponse, NetworkError>, Never> {
      //  let url = URL(string: "Your_URL")!
        let bookKey = parameters.bookKey
        let date = parameters.date
        let url = "\(Constant.BASE_URL)/books/month?bookKey=\(bookKey)&date=\(date)"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: CalendarResponse.self)
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
