//
//  SystemManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/01.
//

import Foundation
import StoreKit
import Combine

class IAPManager : NSObject, ObservableObject{
    let productIDs: [String] = [IAPProducts.FloneyPlusMonthly.rawValue]
    var purchasedProductIDs: Set<String> = []
    
    @Published var products: [Product] = []
    
    //private var entitlementManager: EntitlementManager? = nil
    private var updates: Task<Void, Never>? = nil
    
    override init() {//entitlementManager: EntitlementManager
        //self.entitlementManager = entitlementManager
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        updates?.cancel()
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                await self?.updatePurchasedProducts()
            }
        }
    }
}

//MARK: IAP
extension IAPManager {
    func loadProducts() async {
        do {
            self.products = try await Product.products(for: productIDs)
                .sorted(by: { $0.price > $1.price })
            print(self.products)
        } catch {
            print("Failed to fetch products!")
        }
    }
    
    func buyProduct(_ product: Product) async {
        LoadingManager.shared.update(showLoading: true, loadingType: .dimmedLoading)
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                // Successful purhcase
                await transaction.finish()
                await self.updatePurchasedProducts()
            case let .success(.unverified(_, error)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                print("Unverified purchase. Might be jailbroken. Error: \(error)")
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                print("User cancelled!")
                break
            @unknown default:
                print("Failed to purchase the product!")
                break
            }
        } catch {
            print("Failed to purchase the product!")
        }
        LoadingManager.shared.update(showLoading: false, loadingType: .dimmedLoading)
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            let expiresDate = transaction.expirationDate
            //let date = Date(timeIntervalSince1970: expiresDate)
            //print(date)
            print("expiresDate = \(expiresDate)")
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        //self.entitlementManager?.hasPro = !self.purchasedProductIDs.isEmpty
    }
    
    func getTransactionInfo() async -> Int {
        var id = 0
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            id = Int(transaction.originalID)
        }
        return id
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print(error)
        }
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
