//
//  IAPHelper.swift
//  Floney
//
//  Created by 남경민 on 2023/09/01.
//

import Foundation

import StoreKit
import Alamofire

public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

class IAPHelper: NSObject  {
    // 전체 상품
    private let productIdentifiers: Set<String>
    // 구매한 상품
    private var purchasedProductIDList: Set<String> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    public init(productIds: Set<String>) {
        productIdentifiers = productIds
        
        self.purchasedProductIDList = productIds.filter{ UserDefaults.standard.bool(forKey: $0) == true}
          
        super.init()
        SKPaymentQueue.default().add(self)  // App Store와 지불정보를 동기화하기 위한 Observer 추가
    }
  
    // App Store Connect에서 등록한 인앱결제 상품들을 가져올 때
    // 상품 로드 요청
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self    // 추후 delegate 추가
        productsRequest!.start()
    }
    
}

//MARK: SKProductRequestDelegate
extension IAPHelper: SKProductsRequestDelegate {
    // 인앱결제 상품 리스트를 가져온다
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }
    
    // 상품 리스트 가져오기 실패할 경우
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    // 핸들러 초기화
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

//MARK: SKPaymentTransactionObserver
extension IAPHelper: SKPaymentTransactionObserver {
  
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred, .purchasing:
                break
            @unknown default:
                break
                // close loading
                //SystemManager.shared.closeLoading()
            }
        }
    }
    
    // 구입 성공
    private func complete(transaction: SKPaymentTransaction) {
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // 복원 성공
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        // 구매한 인앱 상품 키에 대한 UserDefaults Bool 값 변경
        purchasedProductIDList.insert(productIdentifier)
        print("restore = \(productIdentifier)")
        UserDefaults.standard.set(true, forKey: productIdentifier)
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // 구매 실패
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        deliverPurchaseNotificationFor(identifier: nil)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // 구매한 인앱 상품 키를 UserDefaults로 로컬에 저장
    // 구매 완료 후 조치
    private func deliverPurchaseNotificationFor(identifier: String?) {
        if let identifier = identifier {
            // 구매한 인앱 상품 키에 대한 UserDefaults Bool 값 변경
            purchasedProductIDList.insert(identifier)
            UserDefaults.standard.set(true, forKey: identifier)
            // 성공 노티 전송
            NotificationCenter.default.post(
                name: .IAPServicePurchaseNotification,
                object: (true, identifier)
            
            )
        } else {
            // 실패 노티 전송
            NotificationCenter.default.post(
                name : .IAPServicePurchaseNotification,
                object: (false, "")
            )
        }
        //SystemManager.shared.closeLoading()
        
    }
}
//MARK: 구매 이력
extension IAPHelper {
    // 구매이력 영수증 가져오기 - 검증용
    public func getReceiptData() -> String? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                return receiptString
            }
            // 영수증 가져오기 실패
            catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
                return nil
            }
        }
        return nil
    }
    
    // 영수증 검증
    func verifyReceipt() {
        // 애플의 테스트 환경용 영수증 검증 URL
        let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
        
        // 애플의 실제 환경용 영수증 검증 URL (실제 환경에서만 사용)
        // let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"

        if let encodedReceiptData = getReceiptData() {
            let parameters = ReceiptRequest(receiptData: encodedReceiptData, password: Secret.APP_SHARE_PASSWORD, excludeOldTransactions: true)
            print(encodedReceiptData)
            
            AF.request(
                verifyReceiptURL,
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder())
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonResponse = value as? [String: Any] {
                        print(jsonResponse)
                        self.sendToServer(receiptData: jsonResponse)
                    }
                    print("Validation success: \(value)")
                case .failure(let error):
                    print("Error verifying receipt: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func sendToServer(receiptData: [String: Any]) {
        if let latestReceiptInfo = (receiptData["latest_receipt_info"] as? [[String: Any]])?.first,
           let pendingRenewalInfo = (receiptData["pending_renewal_info"] as? [[String: Any]])?.first {

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
                    return "active"
                } else {
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

            print("서버에 보낼 데이터 : \(result)")
            self.postSubscriptionInfo(parameters: result)
            
        }
    }
    
    // 구입 내역을 복원할 때
    public func restorePurchases() {
        for productID in productIdentifiers {
            UserDefaults.standard.set(false, forKey : productID)
        }
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func postSubscriptionInfo(parameters: IAPInfoRequest) {
        let url = "\(Constant.BASE_URL)/users/subscribe"
        let token = Keychain.getKeychainValue(forKey: .accessToken)!
        print(url)
        print("post subscription \(parameters)")
        print(token)
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Authorization": "Bearer \(token)"])
        .response { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    print("Failed to retrieve the status code.")
                    return
                }
                
                if statusCode == 200 {
                    print("change subscription info Success")
                } else {
                    // Optionally, handle other status codes or decode error from the response
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    print("Error in success with status code other than 200: \(backendError)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
            
        }
    }
}

//MARK: 구매
extension IAPHelper {
    // 인앱결제 상품을 구입할 때
    public func buyProduct(_ product: SKProduct) {
        //SystemManager.shared.openLoading()
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    // 이미 구매한 상품인가
    func isProductPurchased(_ productID: String) -> Bool {
        return self.purchasedProductIDList.contains(productID)
    }
}



struct ReceiptRequest: Encodable {
    var receiptData: String
    var password: String
    var excludeOldTransactions : Bool

    enum CodingKeys: String, CodingKey {
        case receiptData = "receipt-data"
        case password
        case excludeOldTransactions = "exclude-old-transactions"
    }
}

