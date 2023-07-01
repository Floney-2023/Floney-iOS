//
//  SignInDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import Alamofire
import Combine

/*
 class SignInDataManager: ObservableObject {
 func postSignIn(_ parameters: SignInRequest) {
 AF.request("\(Constant.BASE_URL)/users/logIn", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
 .validate()
 .responseDecodable(of: SignInResponse.self) { response in
 switch response.result {
 case .success(let response):
 // 성공했을 때
 if response.isSuccess, let result = response.result {
 print(result.accessToken)
 self.didSuccessSignIn(result)
 }
 // 실패했을 때
 else {
 switch response.code {
 case 2022: self.failedToRequest(message: "이메일 혹은 휴대폰 번호를 입력해주세요.")
 case 2012: self.failedToRequest(message: "비밀번호 값을 입력해주세요.")
 case 3014: self.failedToRequest(message: "없는 아이디거나 비밀번호가 틀렸습니다.")
 case 3015: self.failedToRequest(message: "탈퇴 회원입니다.")
 case 4012: self.failedToRequest(message: "비밀번호 복호화에 실패하였습니다.")
 default: self.failedToRequest(message: "다시 입력해주세요.")
 }
 }
 case .failure(let error):
 print(error.localizedDescription)
 self.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
 }
 }
 }
 
 
 }
 
 extension SignInDataManager {
 func didSuccessSignIn(_ result: SignInResult) {
 //자동로그인을 위해 토큰 저장
 UserDefaults.standard.set(result.refreshToken, forKey: "UserRefreshToken")
 UserDefaults.standard.set(result.accessToken, forKey: "UserAccessToken")
 UserDefaults.standard.set(result.userIdx, forKey: "UserIdx")
 }
 
 func failedToRequest(message: String) {
 //self.presentAlert(title: message)
 }
 }
 */
protocol SignInProtocol {
    func postSignIn(_ parameters:SignInRequest) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>
    func kakaoSignIn(_ token:String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>
    func googleSignIn(_ token:String) -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>

    func checkKakao(_ token:String) -> AnyPublisher<Bool, Error>
    func checkgoogle(_ token:String) -> AnyPublisher<Bool, Error>
    
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
    
    func findPassword(email: String) -> AnyPublisher<Void, NetworkError> {
        let url = "\(Constant.BASE_URL)/users/password/find?email=\(email)"
       
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        
        return AF.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default)
                          //headers: ["Authorization":"Bearer \(token)"]
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
