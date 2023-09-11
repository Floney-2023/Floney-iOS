//
//  SystemManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/01.
//

import Foundation
import StoreKit

class IAPManager {
    static let shared = IAPManager()
    var productList: [SKProduct] = []
    private init() {
        iapHelper = IAPHelper(productIds: Set<String>([IAPProducts.FloneyPlusYearly.rawValue, IAPProducts.FloneyPlusMonthly.rawValue]))
    }
    
    private var iapHelper : IAPHelper
    
}

//MARK: IAP
extension IAPManager {
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
}
