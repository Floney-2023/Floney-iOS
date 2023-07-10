//
//  AnalysisDataManager.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import Alamofire
import Combine

protocol AnalysisProtocol {
   
}

class AnalysisService {
    static let shared: AnalysisProtocol = AnalysisService()
    private init() { }
}

extension AnalysisService: AnalysisProtocol {
    
}
