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
import FirebaseRemoteConfig

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
                        //fetchMaintenanceTime()
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
    
    func fetchMaintenanceTime() {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        // Remote Config 설정 초기화
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 600 
        remoteConfig.configSettings = settings
        
        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                print("Remote Config fetch error: \(error)")
                return
            }
            
            // 시작 및 종료 시간 파싱
            if let startTimeString = remoteConfig["ios_maintenance_start_time"].stringValue,
               let endTimeString = remoteConfig["ios_maintenance_end_time"].stringValue {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                print(startTimeString)
                print(endTimeString)
                if let startDate = dateFormatter.date(from: startTimeString),
                   let endDate = dateFormatter.date(from: endTimeString) {
                    self.checkMaintenancePeriod(startDate: startDate, endDate: endDate)
                }
            }
        }
    }
    
    // 현재 시간이 중단 시간에 포함되는지 확인하고 팝업 표시
    func checkMaintenancePeriod(startDate: Date, endDate: Date) {
        print("checkmaintenanceperiod")
        let currentDate = Date()
        print("startDate=\(startDate)")
        print(endDate)
        print(currentDate)
        if currentDate >= startDate && currentDate <= endDate {
            print("해당 시간 안에 있음")
            self.showMaintenancePopup()
        }
    }
    
    func showMaintenancePopup() {
        let alert = UIAlertController(
            title: "앱 일시 중단 알림",
            message: "원활한 앱 사용을 위해 앱 점검을 진행합니다. 2024.11.14 22:00 - 2024.11.15 09:00 동안 앱 사용이 불가하니 양해 부탁드립니다.",
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: "확인", style: .default) { _ in
            
        }
        alert.addAction(updateAction)
        DispatchQueue.main.async {
            guard let topVC = Utilities.shared.topViewController() else {
                return
            }
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
