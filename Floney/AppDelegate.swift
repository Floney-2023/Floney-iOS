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
//import FirebaseDynamicLinks
import AppsFlyerLib

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
        
        //AppsFlyerLib.shared().appsFlyerDevKey = ""
        //AppsFlyerLib.shared().appleAppID = "YOUR_APP_ID"
        //AppsFlyerLib.shared().delegate = self
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
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
    
   
    
}
