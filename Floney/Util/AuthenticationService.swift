//
//  AuthenticationService.swift
//  Floney
//
//  Created by 남경민 on 2023/06/28.
//

import Foundation

class AuthenticationService: ObservableObject {
    
    static let shared = AuthenticationService()  // Singleton instance
    
    @Published var isUserLoggedIn: Bool = false
    @Published var tokenExpired: Bool = false

    func logoutDueToTokenExpiration() {
        // 로그아웃 처리
        self.isUserLoggedIn = false
    }
    func logIn() {
        // 로그아웃 처리
        self.isUserLoggedIn = true
    }
}
