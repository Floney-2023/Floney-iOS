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
    
    var tokenViewModel = TokenReissueViewModel()
    @Published var showingShareSheet = false
    @Published var hasDeepLink = false
    @Published var inviteStatus = false
    @Published var settlementStatus = false
    @Published var inviteCode: String?
    
    @Published var shortenedUrl : String?
    @Published var bookKey : String?
    @Published var settlementId : Int?
    
    var dataManager: CalculateProtocol = CalculateService.shared
    
    func generateDeepLink(inviteCode: String) -> String {

        let baseUrl = "https://floney.onelink.me/ZpHw/sm5liatr"

        let urlToShare: String = "\(baseUrl)?inviteCode=\(inviteCode)"
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
                }
                if queryItem.name == "settlementId" {
                    print("settlementId: \(queryItem.value ?? "")")
                    self.settlementId = Int(queryItem.value!)
                    if let settlementId = settlementId {
                        dataManager.getSettlementDetail(id: settlementId)
                            .sink {  (dataResponse) in
                                if dataResponse.error != nil {
                                    self.createAlert(with: dataResponse.error!, retryRequest: {
                                        
                                    })
                                    // 에러 처리
                                    print(dataResponse.error)
                                } else {
                                    print("--정산 내역 디테일 요청 성공--")
                                    Keychain.setKeychain(self.bookKey!, forKey: .bookKey)
                                    self.hasDeepLink = true
                                    self.settlementStatus = true
                                }
                            }.store(in: &cancellableSet)
                    }
                }
            }
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
                    self.createAlert(with: dataResponse.error!, retryRequest: {
                        self.generateSettlementLink(settlementId: settlementId, bookKey: bookKey)
                    })
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
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
        //loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        if let backendError = error.backendError {
            guard let serverError = ServerError(rawValue: backendError.code) else {
                // 서버 에러 코드가 정의되지 않은 경우의 처리
                //showAlert(message: "알 수 없는 서버 에러가 발생했습니다.")
                return
            }
            if error.backendError?.code != "U006" && error.backendError?.code != "B006" {
                AlertManager.shared.handleError(serverError)
            }
            
            // 에러코드에 따른 추가 로직
            if let errorCode = error.backendError?.code {
                switch errorCode {
                    // 토큰 재발급
                case "U006" :
                    tokenViewModel.tokenReissue {
                        // 토큰 재발급 성공 시, 원래의 요청 재시도
                        retryRequest()
                    }
                case "B006" :
                    BlackAlertManager.shared.handleError(title: "접근 권한이 없어요", message: "해당 가계부의 멤버가 아닙니다.\n소속된 가계부를 다시 확인해 주세요.")
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
    }}
