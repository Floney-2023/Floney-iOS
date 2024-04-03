//
//  FloneyApp.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//
import UIKit
import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import GoogleSignInSwift

@main
struct FloneyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
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
                .onChange(of: scenePhase) { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        checkForUpdates()
                    default:
                        break
                    }
                }
        }
    }
    
    func checkForUpdates() {
        Task {
            do {
                let (minimumSupportedVersion, forceUpdate) = try await AppVersionCheck().minimumVersionByFirebase()
                let currentVersion = AppVersionCheck.appVersion
                print("최소 지원 버전: \(minimumSupportedVersion ?? "알 수 없음"), 강제 업데이트 필요: \(forceUpdate ?? false)")
                print("현재 기기 버전: \(currentVersion)")
                guard let minimumSupportedVersion = minimumSupportedVersion, let currentVersion = currentVersion else {
                    print("최소 지원 버전이 null이거나 현재 기기 버전이 null")
                    return
                }
                
                if currentVersion.compare(minimumSupportedVersion, options: .numeric) == .orderedAscending {
                    showUpdateAlert(version: minimumSupportedVersion)
                }
            } catch {
                print("버전 정보를 가져오는 데 실패했습니다: \(error)")
            }
        }
    }
    // 알럿을 띄우는 메소드
    func showUpdateAlert(version: String) {
        let alert = UIAlertController(
            title: "업데이트 알림",
            message: "더 나은 서비스를 위해 플로니가 수정되었어요! 업데이트해주시겠어요?",
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            
            // 업데이트 버튼을 누르면 해당 앱스토어로 이동한다.
#if DEBUG
            AppVersionCheck().openUpdateDevApp()
#else
            AppVersionCheck().openAppStore()
#endif
            
        }
        alert.addAction(updateAction)
        guard let topVC = Utilities.shared.topViewController() else {
            return
        }
        topVC.present(alert, animated: true, completion: nil)
    }
}
