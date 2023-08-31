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
import AppsFlyerLib

class AppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate{
    
    
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
        
        AppsFlyerLib.shared().appsFlyerDevKey = Secret.APPS_FLYER_DEV_KEY
        AppsFlyerLib.shared().appleAppID = Secret.APP_ID
        AppsFlyerLib.shared().delegate = self
        // SDK 시작
        AppsFlyerLib.shared().start()
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
    
    @objc func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        if let status = conversionInfo["af_status"] as? String {
            if status == "Non-organic" {
                if let sourceID = conversionInfo["media_source"] , let campaign = conversionInfo["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID) Campaign: \(campaign)")
                }
            } else {
                print("This is an Organic install.")
            }
        }
    }
        
    @objc func onConversionDataFail(_ error: Error) {
        print("\(error)")
    }
   
    
}
