//
//  Constant.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import Foundation

struct Constant {
#if DEBUG
    static let BASE_URL = "https://floney-dev.site"
#else
    static let BASE_URL = "https://floney-server.site"
#endif
    
    static let appID = "id6462989500"
}
