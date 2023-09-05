//
//  SignUpDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//
import Alamofire
import Combine

protocol SignUpProtocol {
    func postSignUp(_ parameters:SignUpRequest) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never>
    func kakaoSignUp(_ parameters:SignUpRequest, _ token: String) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never>
    func googleSignUp(_ parameters:SignUpRequest, _ token: String) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never>
    func authEmail(_ parameters:AuthEmailRequest) -> AnyPublisher<Int, NetworkError>
}


class SignUp {
    static let shared: SignUpProtocol = SignUp()
    private init() { }
}

extension SignUp: SignUpProtocol {
    func postSignUp(_ parameters:SignUpRequest) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/users/signup"
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder())
            .validate()
            .publishDecodable(type: SignUpResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func kakaoSignUp(_ parameters:SignUpRequest, _ token: String) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/auth/kakao/signup?token=\(token)"
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder())
            .validate()
            .publishDecodable(type: SignUpResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func googleSignUp(_ parameters:SignUpRequest, _ token: String) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never> {
        let url = "\(Constant.BASE_URL)/auth/google/signup?token=\(token)"
        return AF.request(url,
                          method: .post,
                          parameters: parameters,
                          encoder: JSONParameterEncoder())
            .validate()
            .publishDecodable(type: SignUpResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    func authEmail(_ parameters:AuthEmailRequest) -> AnyPublisher<Int, NetworkError> {
        let url = "\(Constant.BASE_URL)/users/email?email=\(parameters.email)"
        print(url)

        return AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding : JSONEncoding.default)
            .validate()
            .publishData()
            .tryMap { result in
                // Check the status code
                if let statusCode = result.response?.statusCode {
                    print("Status Code: \(statusCode)")
                    if statusCode == 200 {
                        // Decode the response
                        let number = try JSONDecoder().decode(Int.self, from: result.data ?? Data())
                        return number
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

/*
 .map { response in
 response.mapError { error in
 let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
 return NetworkError(initialError: error, backendError: backendError)
 }
 }*/
// .receive(on: DispatchQueue.main)
//.eraseToAnyPublisher()
