//
//  NetworkError.swift
//  Floney
//
//  Created by 남경민 on 2023/05/01.
//

import Foundation
import Alamofire

struct NetworkError: Error {
    let initialError: AFError
    let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var code: String
    var message: String
    var provider : String?
}
