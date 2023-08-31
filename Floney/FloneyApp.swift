//
//  FloneyApp.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import SwiftUI


@main
struct FloneyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .onOpenURL { url in
                    // Handle the URL
                    if let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems {
                        if let inviteCode = queryItems.first(where: { $0.name == "inviteCode" })?.value {
                            // Now you have the invite code
                            // If user is not logged in, navigate to login/signup, else handle the invite code
                            AppLinkManager.shared.hasDeepLink = true
                            AppLinkManager.shared.inviteCode = inviteCode
                        }
                    }
                }
                
        }
    }
}
