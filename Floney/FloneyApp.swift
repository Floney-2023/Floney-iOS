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
        }
    }
}
