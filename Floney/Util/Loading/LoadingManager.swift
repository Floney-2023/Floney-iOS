//
//  LoadingManager.swift
//  Floney
//
//  Created by 남경민 on 2023/09/11.
//

import Foundation

enum LoadingType {
    case floneyLoading
    case progressLoading
    case dimmedLoading
    
    var value: String {
        switch self {
        case .floneyLoading:
            return "floneyLoading"
        case .progressLoading:
            return "progressLoading"
        case .dimmedLoading:
            return "dimmedLoading"
        }
    }
}

class LoadingManager: ObservableObject {
    static let shared = LoadingManager()  // Singleton instance
    @Published var showLoadingForSubscribe = false
    @Published var showLoading = false
    @Published var loadingType : LoadingType = .progressLoading
    
    
    func update(showLoading: Bool, loadingType : LoadingType) {
        self.showLoading = showLoading
        self.loadingType = loadingType
    }
}
