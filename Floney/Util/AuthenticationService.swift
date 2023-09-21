//
//  AuthenticationService.swift
//  Floney
//
//  Created by 남경민 on 2023/06/28.
//

import Foundation

class AuthenticationService: ObservableObject {
    
    static let shared = AuthenticationService()  // Singleton instance
    
    @Published var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    @Published var tokenExpired: Bool = false
    @Published var bookStatus: Bool = false
 
    init() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            BookExistenceViewModel.shared.getBookExistence() // 유효 가계부 체크
        }
    }
    func logoutDueToTokenExpiration() {
        // 로그아웃 처리
        self.isUserLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    func logIn() {
        // 로그인 처리
        self.isUserLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    func autoLoginWithToken() {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            self.isUserLoggedIn = true
        }
    }
}
