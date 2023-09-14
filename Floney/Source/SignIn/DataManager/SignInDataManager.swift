//
//  SignInDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import Alamofire
import Combine

protocol SignInProtocol {
    func postSignIn(_ parameters:SignInRequest) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>
    func kakaoSignIn(_ token:String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>
    func googleSignIn(_ token:String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>
    func appleSignIn(_ token:String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>

    func checkKakao(_ token:String) -> AnyPublisher<Bool, Error>
    func checkgoogle(_ token:String) -> AnyPublisher<Bool, Error>
    func checkApple(_ token:String) -> AnyPublisher<Bool, Error>
    func findPassword(email: String) -> AnyPublisher<Void, NetworkError>
}

class SignIn {
    static let shared: SignInProtocol = SignIn()
    private init() { }
}

extension SignIn: SignInProtocol {
    
    func postSignIn(_ parameters:SignInRequest) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never> {
        //  let url = URL(string: "Your_URL")!
        let url = "\(Constant.BASE_URL)/users/login"
        print(parameters)
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder())
        .validate()
        .publishDecodable(type: SignInResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func checkKakao(_ token: String) -> AnyPublisher<Bool, Error> {
        let url = "\(Constant.BASE_URL)/auth/kakao/check?token=\(token)"
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding : JSONEncoding.default)
        .validate()
        .publishData()
        .tryMap { result in
            guard let data = result.data else {
                //AFError.responseValidationFailed(reason: .dataFileNil)
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
            
            // Try to decode BackendError
            if let backendError = try? JSONDecoder().decode(BackendError.self, from: data) {
                throw NetworkError(initialError: AFError.createURLRequestFailed(error: backendError), backendError: backendError)
            }
            
            guard let responseBool = Bool(String(data: data, encoding: .utf8) ?? "") else {
                //AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
            return responseBool
        }
        .mapError { $0 as? NetworkError ?? NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil) }
        .eraseToAnyPublisher()
        
    }
    //MARK: 
    func checkgoogle(_ token: String) -> AnyPublisher<Bool, Error> {
        let url = "\(Constant.BASE_URL)/auth/google/check?token=\(token)"
        
        return AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding : JSONEncoding.default)
        .validate()
        .publishData()
        .tryMap { result in
            guard let data = result.data else {
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
            
            // Try to decode BackendError
            if let backendError = try? JSONDecoder().decode(BackendError.self, from: data) {
                throw NetworkError(initialError: AFError.createURLRequestFailed(error: backendError), backendError: backendError)
            }
            
            guard let responseBool = Bool(String(data: data, encoding: .utf8) ?? "") else {
    
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
            return responseBool
        }
        .mapError { $0 as? NetworkError ?? NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil) }
        .eraseToAnyPublisher()
    }
    //MARK:
    func checkApple(_ token: String) -> AnyPublisher<Bool, Error> {
        let url = "\(Constant.BASE_URL)/auth/apple/check?token=\(token)"
        
        return AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding : JSONEncoding.default)
        .validate()
        .publishData()
        .tryMap { result in
            guard let data = result.data else {
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
            
            // Try to decode BackendError
            if let backendError = try? JSONDecoder().decode(BackendError.self, from: data) {
                throw NetworkError(initialError: AFError.createURLRequestFailed(error: backendError), backendError: backendError)
            }
            
            guard let responseBool = Bool(String(data: data, encoding: .utf8) ?? "") else {
    
                throw NetworkError(initialError: result.error!, backendError: nil)
            }
            return responseBool
        }
        .mapError { $0 as? NetworkError ?? NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil) }
        .eraseToAnyPublisher()
    }
    //MARK: 카카오 간편 로그인
    func kakaoSignIn(_ token: String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never> {
        //  let url = URL(string: "Your_URL")!
        let url = "\(Constant.BASE_URL)/auth/kakao/login?token=\(token)"
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
        .validate()
        .publishDecodable(type: SignInResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    //MARK: 구글 간편 로그인
    func googleSignIn(_ token: String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never> {
        //  let url = URL(string: "Your_URL")!
        let url = "\(Constant.BASE_URL)/auth/google/login?token=\(token)"
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
        .validate()
        .publishDecodable(type: SignInResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    //MARK: 애플 간편 로그인
    func appleSignIn(_ token: String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never> {
        //  let url = URL(string: "Your_URL")!
        let url = "\(Constant.BASE_URL)/auth/apple/login?token=\(token)"
        print(url)
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
        .validate()
        .publishDecodable(type: SignInResponse.self)
        .map { response in
            response.mapError { error in
                let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                return NetworkError(initialError: error, backendError: backendError)
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    //MARK: 비밀번호 찾기
    func findPassword(email: String) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/users/password/find?email=\(email)"
       
 
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
          
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
