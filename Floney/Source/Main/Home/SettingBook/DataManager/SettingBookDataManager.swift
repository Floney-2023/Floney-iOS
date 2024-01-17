//
//  SettingBookDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/30.
//

import Foundation

import Alamofire
import Combine

protocol SettingBookProtocol {
    func getBookInfo(_ parameters:BookInfoRequest) -> AnyPublisher<DataResponse<BookInfoResponse, NetworkError>, Never>
    func changeProfile(parameters: BookProfileRequest) -> AnyPublisher<Void, NetworkError>
    func changeNickname(parameters: BookNameRequest) -> AnyPublisher<Void, NetworkError>
    func changeProfileStatus(parameters: SeeProfileRequest) -> AnyPublisher<Void, NetworkError>
    func setBudget(parameters: SetBudgetRequest) -> AnyPublisher<Void, NetworkError>
    func setAsset(parameters: SetAssetRequest) -> AnyPublisher<Void, NetworkError>
    func getShareCode(_ parameters:BookInfoRequest) -> AnyPublisher<DataResponse<ShareCodeResponse, NetworkError>, Never>
    func exitBook(parameters: BookInfoRequest) -> AnyPublisher<Void, NetworkError>
    func deleteBook(parameters: BookInfoRequest) -> AnyPublisher<Void, NetworkError>
    func resetBook(parameters: BookInfoRequest) -> AnyPublisher<Void, NetworkError>
    func setCarryOver(parameters: SetCarryOver) -> AnyPublisher<Void, NetworkError>
    func downloadExcelFile(parameters: DownloadExcelRequest) -> AnyPublisher<URL, Error>
    func setCurrency(_ parameters:SetCurrencyRequest) -> AnyPublisher<DataResponse<SetCurrencyResponse, NetworkError>, Never>
    func getBudget(_ parameters:GetBudgetRequest) -> AnyPublisher<DataResponse<GetBudgetResponse, NetworkError>, Never>
}

class SettingBookService {
    static let shared: SettingBookProtocol = SettingBookService()
    private init() { }
}

extension SettingBookService: SettingBookProtocol {
    
    func getBudget(_ parameters: GetBudgetRequest) -> AnyPublisher<Alamofire.DataResponse<GetBudgetResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/budget?bookKey=\(parameters.bookKey)&startYear=\(parameters.date)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: GetBudgetResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    /*
    func downloadExcelFile(bookKey: String) -> AnyPublisher<URL, Error> {
        let url = "\(Constant.BASE_URL)/books/excel?bookKey=\(bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        return Future<URL, Error> { promise in
            guard let url = URL(string: url) else {
                promise(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
                return
            }
            
            let destination: DownloadRequest.Destination = { _, _ in
                let tempDir = FileManager.default.temporaryDirectory
                let filePath = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("xlsx")
                return (filePath, [.removePreviousFile, .createIntermediateDirectories])
            }
            AF.download(url, headers: headers,to: destination)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }
                .response { response in
                    if let error = response.error {
                        promise(.failure(error))
                    } else if let filePath = response.fileURL {
                        print(filePath)
                        promise(.success(filePath))
                    } else {
                        promise(.failure(NSError(domain: "Unknown Error", code: 500, userInfo: nil)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }*/

    func downloadExcelFile(parameters: DownloadExcelRequest) -> AnyPublisher<URL, Error> {
        let url = "\(Constant.BASE_URL)/books/excel"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        return Future<URL, Error> { promise in
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoder: JSONParameterEncoder(),
                       headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let tempDir = FileManager.default.temporaryDirectory
                        let contentDisposition = response.response?.headers.value(for: "Content-Disposition")
                        print("contentDisposition : \(contentDisposition)")
                        print("filenameFromContentDisposition : \(contentDisposition?.filenameFromContentDisposition())")
                        let filename = contentDisposition?.filenameFromContentDisposition() ?? UUID().uuidString
                        let fileURL = tempDir.appendingPathComponent(filename).appendingPathExtension("xlsx")
                        do {
                            try data.write(to: fileURL)
                            promise(.success(fileURL))
                        } catch {
                            promise(.failure(error))
                        }
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    func setCurrency(_ parameters: SetCurrencyRequest) -> AnyPublisher<Alamofire.DataResponse<SetCurrencyResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/books/info/currency"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder : JSONParameterEncoder(),
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: SetCurrencyResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func resetBook(parameters: BookInfoRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/delete/all?bookKey=\(parameters.bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("exit book : \n\(token)")
        
        return AF.request(url,
                          method: .delete,
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
    
    func exitBook(parameters: BookInfoRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/users/out"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("exit book : \n\(token)")
        
        return AF.request(url,
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
    func deleteBook(parameters: BookInfoRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/delete?bookKey=\(parameters.bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("exit book : \n\(token)")
        
        return AF.request(url,
                          method: .delete,
                          parameters: nil,
                          encoding : JSONEncoding.default,
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
    func getShareCode(_ parameters: BookInfoRequest) -> AnyPublisher<DataResponse<ShareCodeResponse, NetworkError>, Never> {
        let bookKey = parameters.bookKey
        let url = "\(Constant.BASE_URL)/books/code?bookKey=\(bookKey)"
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding : JSONEncoding.default,
                          headers: ["Authorization":"Bearer \(token)"])
        .validate()
        .publishDecodable(type: ShareCodeResponse.self)
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
    func changeProfile(parameters: BookProfileRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/bookImg"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("change profile : \n\(token)")
        
        return AF.request(url,
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
    
    
    func changeNickname(parameters: BookNameRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/name"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("change nickname : \n\(token)")
        
        return AF.request(url,
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
    func changeProfileStatus(parameters: SeeProfileRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/seeProfile"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        //print("change nickname : \n\(token)")
        
        return AF.request(url,
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
    func setBudget(parameters: SetBudgetRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/budget"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print(url)
        print("change budget : \(parameters)")
        return AF.request(url,
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
    func setAsset(parameters: SetAssetRequest) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/asset"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        print("set asset : \n\(parameters.asset)")
        
        return AF.request(url,
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
    
    func setCarryOver(parameters: SetCarryOver) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/books/info/carryOver"
        
        let token = Keychain.getKeychainValue(forKey: .accessToken) ?? ""
        
        return AF.request(url,
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
