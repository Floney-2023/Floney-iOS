//
//  Secret.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import Foundation


enum IAPProducts: String {
    case FloneyPlusYearly = "floney_yearly"
    case FloneyPlusMonthly = "floney_monthly"
}

struct Secret {
    static let KAKAO_NATIVE_APP_KEY = "568bf0b356479da518498ee7ed8f9c5c"
    static let GOOGLE_CLIENT_ID = "918730717655-ma64mjo3monaq1ka35b5muug9e3sop7d"
    static let APPS_FLYER_DEV_KEY = "fGUHc4YvfEic7yTRodqJcC"
    static let APP_ID = "6462989500"
    static let IAP_PRODUCT_ID = "21375562"
    static let FCM_KEY = "73debcefa1ba7040592884cd2d07bf54a102e9ba"
    static let NAVER_CLIENT_ID = "5cFbVr8QjUhDpif_uYa9"
    static let NAVER_CLIENT_SECRET = "ApEjSKgq2x"
    static let APP_SHARE_PASSWORD = "d690a14f3c0348afa1c1c3fb9584b482"
    
}
