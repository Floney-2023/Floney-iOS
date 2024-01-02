//
//  FloneyApp.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import GoogleSignInSwift

@main
struct FloneyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .onOpenURL { url in
                    // Handle the URL
                    print("오픈하자마자 url : \(url)")
                
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else {
                        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems {
                            if let inviteCode = queryItems.first(where: { $0.name == "inviteCode" })?.value {
                                // Now you have the invite code
                                // If user is not logged in, navigate to login/signup, else handle the invite code
                                AppLinkManager.shared.hasDeepLink = true
                                AppLinkManager.shared.inviteStatus = true
                                AppLinkManager.shared.inviteCode = inviteCode
                                print("\(AppLinkManager.shared.hasDeepLink)")
                                print("\(AppLinkManager.shared.inviteCode)")
                            } else {
                                print("호출 get original url")
                                AppLinkManager.shared.setBookKeyandSettlementId(url)
                            }
                        }
                    }
                }
        }
    }
}
