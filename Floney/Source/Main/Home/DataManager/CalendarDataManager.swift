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
    func getDayLines(_ parameters:DayLinesRequest) -> AnyPublisher<DataResponse<DayLinesResponse, NetworkError>, Never>
    func getBookInfo(_ parameters:BookInfoRequest) -> AnyPublisher<DataResponse<BookInfoResponse, NetworkError>, Never>
    func getMyInfo() -> AnyPublisher<DataResponse<MyPageResponse, NetworkError>, Never>

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
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("calendar data manager Token : \(token)")
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
    
    func getDayLines(_ parameters:DayLinesRequest) -> AnyPublisher<DataResponse<DayLinesResponse, NetworkError>, Never> {
        let bookKey = parameters.bookKey
        let date = parameters.date
        let url = "\(Constant.BASE_URL)/books/days?bookKey=\(bookKey)&date=\(date)"
        print("daylines : \(url)")
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
            .validate()
            .publishDecodable(type: DayLinesResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func getBookInfo(_ parameters:BookInfoRequest) -> AnyPublisher<DataResponse<BookInfoResponse, NetworkError>, Never> {
    
        let bookKey = parameters.bookKey
   
        let url = "\(Constant.BASE_URL)/books/info?bookKey=\(bookKey)"
        print(url)
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: BookInfoResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    func getMyInfo() -> AnyPublisher<DataResponse<MyPageResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/users/mypage"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("My Info : \n\(token)")
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: MyPageResponse.self)
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
