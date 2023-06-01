//
//  SignUpDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//
import Alamofire
import Combine

/*
class SignUpDataManager: ObservableObject {
    func postSignUp(_ parameters: SignUpRequest) {
        AF.request("\(Constant.BASE_URL)/users/signup", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: SignUpResponse.self) { response in
                switch response.result {
                case .success(let response):
                    // 성공했을 때
                    if response.isSuccess, let result = response.result {
                        self.didSuccessSignUp(result)
                    }
                    // 실패했을 때
                    else {
                        switch response.code {
                        case 2015: self.failedToRequest(message: "이메일을 입력해주세요.")
                        case 2013: self.failedToRequest(message: "휴대폰 번호를 입력해주세요.")
                        case 2010: self.failedToRequest(message: "유저 아이디 값을 입력해주세요.")
                        case 2012: self.failedToRequest(message: "비밀번호 값을 입력해주세요.")
                        case 2021: self.failedToRequest(message: "필수 약관에 동의해주세요.")
                        case 2016: self.failedToRequest(message: "이메일 형식을 확인해주세요.")
                        case 2017: self.failedToRequest(message: "휴대폰 번호 형식을 확인해주세요.")
                        case 2018: self.failedToRequest(message: "중복된 이메일입니다.")
                        case 2019: self.failedToRequest(message: "중복된 휴대폰 번호 입니다.")
                        case 2020: self.failedToRequest(message: "중복된 사용자 이름입니다.")
                        case 2023: self.failedToRequest(message: "생년월일을 입력해주세요.")
                        case 2024: self.failedToRequest(message: "가입에 실패했습니다.")
                        case 4000: self.failedToRequest(message: "데이터베이스 연결에 실패했습니다.")
                        case 4011: self.failedToRequest(message: "비밀번호 암호화에 실패했습니다.")
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

extension SignUpDataManager {
    func didSuccessSignUp(_ result: SignUpResult) {
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

protocol SignUpProtocol {
    func postSignUp(_ parameters:SignUpRequest) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never>
    func kakaoSignUp(_ parameters:SignUpRequest, _ token: String) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never>
    func googleSignUp(_ parameters:SignUpRequest, _ token: String) -> AnyPublisher<DataResponse<SignUpResponse, NetworkError>, Never>
    func authEmail(_ parameters:AuthEmailRequest) -> AnyPublisher<Int, Error>
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

    func authEmail(_ parameters:AuthEmailRequest) -> AnyPublisher<Int, Error> {
        let url = "\(Constant.BASE_URL)/users/email?email=\(parameters.email)"
        
        
        return Future<Int, Error> { promise in
            AF.request(url,
                       method: .get,
                       parameters: nil,
                       encoding : JSONEncoding.default)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case .success(let value):
                    if let intValue = value as? Int {
                        //promise(.success(intValue))
                        print(intValue)
                    } else {
                        //promise(.failure(NetworkError.invalidDataType))
                        
                    }
                case .failure(let error):
                    print((error))
                }
            }
            
        }
        .receive(on: DispatchQueue.main)
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
