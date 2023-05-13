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
        
        let url = "\(Constant.BASE_URL)/books/calendars"
        
        // token을 keychain에 저장해야 함.
    
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJLayIsImlhdCI6MTY4Mzk3NDczNiwiZXhwIjoxNjgzOTc4MzM2fQ.Edbqozc2kyaU5EVhXVM_8ZYMJ5UrbgX_e0TmfEDcm6c"
        return AF.request(url,
                          method: .get,
                          parameters: parameters,
                          encoder: JSONParameterEncoder(),
                          headers: ["Authorization":token])
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
