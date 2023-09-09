//
//  IAPInfoRequest.swift
//  Floney
//
//  Created by 남경민 on 2023/09/02.
//

import SwiftUI

struct IAPInfoRequest :Encodable {
    var originalTransactionId : String
    var transactionId : String
    var productId : String
    var expiresDate : String
    var subscriptionStatus : String
    var renewalStatus : Bool
}

struct SubscriptionRequest : Encodable {
    var subscribe : Bool
}
