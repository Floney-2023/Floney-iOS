//
//  AppLinkManager.swift
//  Floney
//
//  Created by 남경민 on 2023/08/30.
//

import Foundation
import AppsFlyerLib
import Alamofire
import Combine

class AppLinkManager: ObservableObject {
    static let shared = AppLinkManager() // 싱글톤
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var showingShareSheet = false
    @Published var hasDeepLink = false
    @Published var inviteStatus = false
    @Published var settlementStatus = false
    @Published var inviteCode: String?
    
    @Published var shortenedUrl : String?
    @Published var bookKey : String?
    @Published var settlementId : Int?
    
    func generateDeepLink(inviteCode: String) -> String {
        // 대시보드에서 Onelink 생성하면 주는 Short Link이다.
        // 예시로 써놨으며, 이 링크 뒤에 OG 태그를 파라미터로 붙이면 된다.
        let baseUrl = "https://floney.onelink.me/ZpHw/sm5liatr"

        // og 태그에 넣을 데이터들이다.
        //let inviteCode = Keychain.getKeychainValue(forKey: .bookKey)

        // OG태그 데이터를 baseUrl 뒤에 파라미터로 넣는다.
        // 여기서 idx는 링크 클릭했을때 화면이동 시키기 위해서 필요하기 때문에 파라미터로 넘겨주었다.
        let urlToShare: String = "\(baseUrl)?inviteCode=\(inviteCode)"

        // url(string값)에 한글이 들어가 있으면 인코딩 시켜줘야한다.
        // title과 descript에 한글이 들어가있음.
        guard let encodedUrl = urlToShare.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "no_link"}
        
        return encodedUrl
    }
    // 원래 링크로 복호화

    
    func setBookKeyandSettlementId(_ url: URL)  {
        print("호출됨 get original url")
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            for queryItem in components.queryItems ?? [] {
                if queryItem.name == "bookKey" {
                    print("bookKey: \(queryItem.value ?? "")")
                    self.bookKey = queryItem.value
                    Keychain.setKeychain(self.bookKey!, forKey: .bookKey)
                }
                
                if queryItem.name == "settlementId" {
                    print("settlementId: \(queryItem.value ?? "")")
                    self.settlementId = Int(queryItem.value!)
                }
                
            }
            self.hasDeepLink = true
            self.settlementStatus = true
        }
    }
    
    // 정산하기 링크
    func generateSettlementLink(settlementId : Int, bookKey : String) {
        let baseUrl = "https://floney.onelink.me/ZpHw/hmdgif1c"
        let encodedBookKey = bookKey.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let settlementIdString = String(settlementId)
        let encodedSettlementId = settlementIdString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlToShare: String = "\(baseUrl)?settlementId=\(encodedSettlementId)&bookKey=\(encodedBookKey)"
        print("original url : \(urlToShare)")
        let service = NaverShortenerService()
        service.getShortenedURL(for: urlToShare)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    // 에러 처리
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.shortenedUrl = dataResponse.value?.result.url
                    print("네이버 요청 성공")
                    print("shortened link : \(self.shortenedUrl)")
                    print("original link : \(dataResponse.value?.result.orgUrl)")
                    self.showingShareSheet = true
                }
            }.store(in: &cancellableSet)
        
    }
    func createAlert( with error: NetworkError) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            AlertManager.shared.handleError(serverError)
            // 에러 메시지 처리
            //showAlert(message: serverError.errorMessage)
            
            // 에러코드에 따른 추가 로직
            if let errorCode = error.backendError?.code {
                switch errorCode {
                    // 토큰 재발급
                case "U006" :
                    AuthenticationService.shared.logoutDueToTokenExpiration()
                // 아예 틀린 토큰이므로 재로그인해서 다시 발급받아야 함.
                case "U007" :
                    AuthenticationService.shared.logoutDueToTokenExpiration()
                default:
                    break
                }
            }
        } else {
            // BackendError 없이 NetworkError만 발생한 경우
            //showAlert(message: "네트워크 오류가 발생했습니다.")
            
        }
    }
}
