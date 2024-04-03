//
//  AppVersionCheck.swift
//  Floney
//
//  Created by 남경민 on 4/3/24.
//

import Foundation
import FirebaseRemoteConfig

final class AppVersionCheck {
    // 앱 자체 버전
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appStoreopenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(Constant.appID)"
    static let devAppopenUrlString = "https://appdistribution.firebase.google.com/testerapps/1:918730717655:ios:c2692564a6bba76fd2b392"
    
    // 앱스토어의 버전 체크
    func latestVersion() -> String? {
        let appleID = Constant.appID
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appleID)&country=kr"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String else {
            return nil
        }
        return appStoreVersion
    }
    
    // remoteConfig의 버전
    func minimumVersionByFirebase() async throws -> (String?, Bool?) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
#if DEBUG
        settings.minimumFetchInterval = 0
        let minimumVersion = "ios_minimum_version_dev"
        let forceUpdate = "ios_force_update_dev"
#else
        settings.minimumFetchInterval = 43200
        let minimumVersion = "ios_minimum_version_prod"
        let forceUpdate = "ios_force_update_prod"
#endif
        remoteConfig.configSettings = settings
        do {
            let status = try await remoteConfig.fetch()
            if status == .success {
                let activated: Bool = try await remoteConfig.activate()
                return (remoteConfig[minimumVersion].stringValue, remoteConfig[forceUpdate].boolValue)
            } else {
                return (nil, nil)
            }
        } catch {
            throw error
        }
    }
    
    // 해당 앱의 앱스토어로 이동
    func openAppStore() {
        guard let url = URL(string: AppVersionCheck.appStoreopenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    // 개발 앱의 업데이트로 이동
    func openUpdateDevApp() {
        guard let url = URL(string: AppVersionCheck.devAppopenUrlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
