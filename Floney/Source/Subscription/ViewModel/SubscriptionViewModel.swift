//
//  SubscriptionViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/09/13.
//

import Foundation
import Combine

class SubscriptionViewModel: ObservableObject {
    var tokenViewModel = TokenReissueViewModel()
    @Published var dismissSubscribe = false
    @Published var remainingPeriod = 0
    @Published var expiresDate = "2020-09-09"
    @Published var productPrice = IAPManager.shared.productList[0].price
    @Published var renewalStatus = false
    private var priceFormatter : NumberFormatter {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = IAPManager.shared.productList[0].priceLocale
        return priceFormatter
    }
    
    @Published var subscriptionInfo: IAPInfoResponse?
    @Published var formattedPrice = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: SubscriptionProtocol
    
    init( dataManager: SubscriptionProtocol = SubscriptionService.shared) {
        self.dataManager = dataManager
        self.getSubscriptionInfo()
    }
    
    func getSubscriptionInfo() {
        dataManager.getSubscriptionInfo()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [weak self] response in
                switch response.result {
                case .success(let info):
                    self?.subscriptionInfo = info
                    if let price = self?.productPrice {
                        self?.formattedPrice = self?.priceFormatter.string(from: price) ?? ""
                    }
                    if let date = Date(fromISO8601: info.expiresDate) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let formattedDate = dateFormatter.string(from: date)
                        print(formattedDate) // 2023-09-13
                        self?.expiresDate = formattedDate
                        
                        let currentDate = Date()
                        let calendar = Calendar.current
                        
                        // 주의: 중간에 시간이 있는 경우, 정확하게 24시간 단위로 계산됩니다.
                        // 그렇기 때문에 일(day) 단위로 비교하려면 두 날짜를 "yyyy-MM-dd" 형식으로 재정렬하는 것이 좋습니다.
                        let currentDayStart = calendar.startOfDay(for: currentDate)
                        let targetDayStart = calendar.startOfDay(for: date)
                        if let diffDays = calendar.dateComponents([.day], from: currentDayStart, to: targetDayStart).day {
                            print("남은 날짜는 \(diffDays)일입니다.")
                            self?.remainingPeriod = diffDays
                        } else {
                            print("날짜 계산에 실패했습니다.")
                        }
                    } else {
                        print("Invalid date string")
                    }
                    self?.renewalStatus = self?.subscriptionInfo?.renewalStatus ?? false
                    
                case .failure(let error):
                    print(error)
                    self?.createAlert(with: error, retryRequest: {
                        self?.getSubscriptionInfo()
                    })
                }
            })
            .store(in: &cancellableSet)
    }
    func createAlert( with error: NetworkError, retryRequest: @escaping () -> Void) {
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
                    tokenViewModel.tokenReissue {
                        // 토큰 재발급 성공 시, 원래의 요청 재시도
                        retryRequest()
                    }
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



extension Date {
    init?(fromISO8601 string: String) {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
}
