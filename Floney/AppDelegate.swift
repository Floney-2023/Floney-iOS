//
//  AppDelegate.swift
//  Floney
//
//  Created by 남경민 on 2023/05/09.
//

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth
import FirebaseCore
import GoogleSignIn
import FirebaseDynamicLinks

class AppDelegate: NSObject, UIApplicationDelegate{
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        KakaoSDK.initSDK(appKey: Secret.KAKAO_NATIVE_APP_KEY, loggingEnable:false) // 카카오 초기화
        FirebaseApp.configure() // firebase 초기화
        
        // google 초기화
        GoogleSignIn.GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
               // GIDSignIn.sharedInstance.clientID = Secret.GOOGLE_CLIENT_ID
            } else {
                
            }
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // dynamic link
        if handleFirebaseLink(app: app, open: url, options: options) {
            return true
        }
        // kakao
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url, options: options)
        }
        
        // google
        if (GIDSignIn.sharedInstance.handle(url)) {
            return true
        }
        
        return false
    }
    
    func handleFirebaseLink(app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            // 동적 링크로부터 데이터를 가져옵니다
            handleIncomingDynamicLink(dynamicLink)
            return true
        }
        return false
    }
    // 동적 링크를 처리하는 함수
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("No incoming link")
            return
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        // bookCode 값을 가져오고 싶다면 URL에서 bookCode를 찾습니다
        let bookCode = components?.queryItems?.first(where: { $0.name == "bookCode" })?.value
        print("Book code is: \(bookCode ?? "No code")")
    }
    
}
