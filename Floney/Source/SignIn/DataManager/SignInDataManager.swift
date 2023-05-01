//
//  SignInDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import Alamofire
import Combine

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


protocol ServiceProtocol {
    func fetchChats() -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func fetchChats() -> AnyPublisher<DataResponse<SignInResponse, NetworkError>, Never> {
        let url = URL(string: "Your_URL")!
        
        return AF.request(url,
                          method: .get)
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
}
