//
//  NotificationManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/02.
//

import Foundation

class NotificationManager: ObservableObject {
    @Published var message: String = "Waiting for notification..."
    
    var notificationObserver: Any?

    init() {
        addNotificationObserver()
    }
    
    deinit {
        removeNotificationObserver()
    }
    // IAP 노티 구독
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePurchaseNoti(_ :)),
            name: .IAPServicePurchaseNotification,
            object: nil
        )
    }
    
    func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: .IAPServicePurchaseNotification, object: nil)
    }
    
    // Notification 결과에 따른 핸들러
    @objc private func handlePurchaseNoti(_ notification : Notification) {
        guard let result = notification.object as? (Bool, String) else { return }
        let isSuccess = result.0
        if isSuccess {
            switch result.1 {
            case IAPProducts.FloneyPlusYearly.rawValue:
                message = "구독이 완료되었습니다."
            case IAPProducts.FloneyPlusMonthly.rawValue :
                message = "구독이 완료되었습니다."
            default :
                break
                
            }
        } else {
            // 구매 중 오류
        }
    }
}
