//
//  SystemManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/01.
//

import Foundation
import StoreKit
import Combine

protocol IAPHelperDelegate: AnyObject {
    func didPurchaseProductSuccessfully(productID: String)
    func didFailToPurchaseProduct(error: Error?)
}

class IAPManager : ObservableObject{
    var tokenViewModel = TokenReissueViewModel()
    // 서버에서 가져온 구독 정보
    @Published var subscriptionInfo: IAPInfoResponse?
    @Published var receiptData: [String: Any]?
    @Published var iapRequest : IAPInfoRequest?
    @Published var bookLeaders: [BookLeaderResponse]?
    @Published var subscriptionStatus : Bool = false
    static let shared = IAPManager()
    var productList: [SKProduct] = []
    private init() {
        iapHelper = IAPHelper(productIds: Set<String>([IAPProducts.FloneyPlusYearly.rawValue, IAPProducts.FloneyPlusMonthly.rawValue]))
        self.iapHelper.delegate = self
    }
    
    private var iapHelper : IAPHelper
    private var cancellableSet: Set<AnyCancellable> = []
    
}

//MARK: IAP
extension IAPManager  {
    // set IAP
    func initIAP() {
        // 상품 정보 가져오기
        iapHelper.requestProducts { [self] success, products in
            if success {
                guard let products = products else { return }
                productList = products
                iapHelper.restorePurchases()
                print("products : \(products)")
                print("productList : \(products)")
            } else {
                print("iAPManager.requestProducts Error")
            }
            
        }
    }
    func verifyReceipt() {
        iapHelper.verifyReceipt()
            .receive(on: DispatchQueue.main) // 결과를 main thread에서 처리합니다.
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    // 성공적으로 완료된 경우 - 여기서 특별한 작업은 필요하지 않을 수 있습니다.   
                    break
                case .failure(let error):
                    // 에러가 발생한 경우
                    print(error)
                    LoadingManager.shared.showLoadingForSubscribe = false
                }
            }, receiveValue: { [weak self] data in
                // 영수증 데이터를 받아온 경우
                self?.receiptData = data
                self?.sendToServer()
            })
            .store(in: &cancellableSet)
    }
    func sendToServer() {
        if let latestReceiptInfo = (receiptData?["latest_receipt_info"] as? [[String: Any]])?.first,
           let pendingRenewalInfo = (receiptData?["pending_renewal_info"] as? [[String: Any]])?.first {
            
            let originalTransactionId = latestReceiptInfo["original_transaction_id"] as? String ?? ""
            let transactionId = latestReceiptInfo["transaction_id"] as? String ?? ""
            let productId = latestReceiptInfo["product_id"] as? String ?? ""
            print(latestReceiptInfo["expires_date_ms"])
            let expiresDateMs = latestReceiptInfo["expires_date_ms"] as? String ?? ""
            print(expiresDateMs)
            var expiresDate : Date = Date()
            if let expiresDateMSDouble = Double(expiresDateMs) {
                expiresDate = Date(timeIntervalSince1970: expiresDateMSDouble / 1000)
                print("변환된 expiresDate :\(expiresDate)")
            }
            let autoRenewStatus = (pendingRenewalInfo["auto_renew_status"] as? String) == "1"
            
            var subscriptionStatus: String {
                if expiresDate > Date() {
                    self.subscriptionStatus = true
                    return "active"
                } else {
                    self.subscriptionStatus = false
                    return "expired"
                }
            }
            // Date 객체를 ISO 8601 형식의 문자열로 변환합니다.
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC로 설정
            let isoDateString = isoFormatter.string(from: expiresDate)
            
            print(expiresDateMs)
            print(expiresDate)
            print(isoDateString) // 예: "2023-09-09T06:42:38Z"
            
            let result = IAPInfoRequest(
                originalTransactionId: originalTransactionId,
                transactionId: transactionId,
                productId: productId,
                expiresDate: isoDateString,
                subscriptionStatus: subscriptionStatus,
                renewalStatus: autoRenewStatus)
            self.iapRequest = result
            
            print("서버에 보낼 데이터 : \(result)")
            
            iapHelper.postSubscriptionInfo(parameters: result)
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { [weak self] response in
                    switch response.result {
                    case .success(let bookLeaders):
                        self?.bookLeaders = bookLeaders
                        LoadingManager.shared.showLoadingForSubscribe = false
                    case .failure(let error):
                        print(error)
                        LoadingManager.shared.showLoadingForSubscribe = false
                    }
                })
                .store(in: &cancellableSet)
        }
    }

    // 구매 확인
    func isProductPurchased(_ productID: String) -> Bool {
        return iapHelper.isProductPurchased(productID)
    }
    // 구매
    func buyProduct(_ productID: String) {
        for product in productList {
            if product.productIdentifier == productID {
                iapHelper.buyProduct(product)
                break
            }
        }
    }
    // 서버에서 구독 정보를 가져오는 함수
    func fetchSubscriptionInfo() {
        iapHelper.getSubscriptionInfo()
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
                case .failure(let error):
                    print(error)
                }
            })
            .store(in: &cancellableSet)
    }
    func getSubscriptionStatus() {
        LoadingManager.shared.showLoadingForSubscribe = true
        iapHelper.getSubscriptionStatus()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                    print(dataResponse.error)
                } else {
                    self.subscriptionStatus = dataResponse.value!.subscribe
                    if self.subscriptionStatus {
                        self.verifyReceipt()
                    } else {
                        LoadingManager.shared.showLoadingForSubscribe = false
                    }
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
                    tokenViewModel.tokenReissue()
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

extension IAPManager: IAPHelperDelegate {
    func didPurchaseProductSuccessfully(productID: String) {
        // 여기서 구매 성공 로직을 수행합니다.
        self.verifyReceipt()
    }

    func didFailToPurchaseProduct(error: Error?) {
        // 구매 실패 시 처리 로직을 수행합니다.
    }
}
