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
    //@StateObject var userSession = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView().environmentObject(AuthenticationService.shared)
                
        }
    }
}
