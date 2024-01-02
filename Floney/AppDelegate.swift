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
import FirebaseMessaging
import AdSupport
import AppTrackingTransparency
import AuthenticationServices
import GoogleSignInSwift

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    var ConversionData: [AnyHashable: Any]? = nil
    var deferred_deep_link_processed_flag:Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
                KakaoSDK.initSDK(appKey: Secret.KAKAO_NATIVE_APP_KEY, loggingEnable:false)
        
        // firebase 초기화
        //FirebaseApp.configure()
        var fileName = "GoogleService-Info"
#if DEBUG
        fileName = fileName + "-dev"
#endif
        let filePath = Bundle.main.path(forResource: fileName, ofType: "plist")!
        let options: FirebaseOptions? = FirebaseOptions.init(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
        
        
        // fcm delegate
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        // 푸시 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("Permission granted: \(granted)")
        }
        application.registerForRemoteNotifications()
        
        // FCM 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                Keychain.setKeychain(token, forKey: .fcmToken)
            }
        }

        // google 초기화
        GoogleSignIn.GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                
            } else {
                
            }
        }
       
        // apple 연동되어 있는지 검증
        if let appleId = Keychain.getKeychainValue(forKey: .appleUserId) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleId) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // Authorization Logic
                    break
                case .revoked, .notFound:
                    // Not Authorization Logic
                    /*
                     DispatchQueue.main.async {
                     self.window?.rootViewController?.showLoginViewController()
                     }*/
                    break
                default:
                    break
                }
            }
        }
        // Apps Flyer 초기화
        //  Set isDebug to true to see AppsFlyer debug logs

        AppsFlyerLib.shared().appsFlyerDevKey = Secret.APPS_FLYER_DEV_KEY
        AppsFlyerLib.shared().appleAppID = Secret.APP_ID
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
        
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().deepLinkDelegate = self
        AppsFlyerLib.shared().appInviteOneLinkID = "ZpHw"
        
        // SDK 시작
        // Subscribe to didBecomeActiveNotification if you use SceneDelegate or just call
        // -[AppsFlyerLib start] from -[AppDelegate applicationDidBecomeActive:]
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification),
                                               // For Swift version < 4.2 replace name argument with the commented out code
                                               name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
                                               object: nil)
        
        // IAP 초기화
        //IAPManager.shared.initIAP()
         
        return true

    }
        
    // 앱이 활성화 될 때마다 호출됨.
    @objc func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .denied:
                    print("AuthorizationSatus is denied")
                case .notDetermined:
                    print("AuthorizationSatus is notDetermined")
                case .restricted:
                    print("AuthorizationSatus is restricted")
                case .authorized:
                    print("AuthorizationSatus is authorized")
                @unknown default:
                    fatalError("Invalid authorization status")
                }
            }
        }
    }
    
    // Open Universal Links
    // For Swift version < 4.2 replace function signature with the commented out code
    // func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool { // this line for Swift < 4.2
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    // Open URI-scheme for iOS 9 and above
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // kakao
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url, options: options)
        }
        // google
        if (GIDSignIn.sharedInstance.handle(url)) {
            return true
        }
        AppsFlyerLib.shared().handleOpen(url, options: options)
        
        return false
    }
    // User logic
    fileprivate func walkToSceneWithParams(inviteCode: String, deepLinkData: [String: Any]?) {
        
    }
    
}

//MARK: deep link
extension AppDelegate: DeepLinkDelegate {
    // 해당 함수가 딥링크 분석
    func didResolveDeepLink(_ result: DeepLinkResult) {
        var inviteCode: String?
        switch result.status {
        case .notFound:
            NSLog("[AFSDK] Deep link not found")
            print("[AFSDK] Deep link not found")
            return
        case .failure:
            print("Error %@", result.error!)
            if let error = result.error {
                print("Error resolving deep link: \(error.localizedDescription)")
            }
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
            print("[AFSDK] Deep link found")
        }
        
        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            print("[AFSDK] Could not extract deep link object")
            return
        }
        
        if deepLinkObj.clickEvent.keys.contains("deep_link_sub2") {
            let ReferrerId:String = deepLinkObj.clickEvent["deep_link_sub2"] as! String
            NSLog("[AFSDK] AppsFlyer: Referrer ID: \(ReferrerId)")
        } else {
            NSLog("[AFSDK] Could not extract referrerId")
        }
        
        let deepLinkStr:String = deepLinkObj.toString()
        NSLog("[AFSDK] DeepLink data is: \(deepLinkStr)")
        
        if( deepLinkObj.isDeferred == true) {
            NSLog("[AFSDK] This is a deferred deep link")
            if (deferred_deep_link_processed_flag == true) {
                NSLog("Deferred deep link was already processed by GCD. This iteration can be skipped.")
                deferred_deep_link_processed_flag = false
                return
            }
        }
        else {
            NSLog("[AFSDK] This is a direct deep link")
        }
        
        inviteCode = deepLinkObj.deeplinkValue
        
        //If deep_link_value doesn't exist
        if inviteCode == nil || inviteCode == "" {
            //check if fruit_name exists
            switch deepLinkObj.clickEvent["fruit_name"] {
            case let s as String:
                inviteCode = s
            default:
                print("[AFSDK] Could not extract deep_link_value or fruit_name from deep link object with unified deep linking")
                return
            }
        }
        
        // This marks to GCD that UDL already processed this deep link.
        // It is marked to both DL and DDL, but GCD is relevant only for DDL
        deferred_deep_link_processed_flag = true
        
        if let inviteCode = inviteCode {
            walkToSceneWithParams(inviteCode: inviteCode, deepLinkData: deepLinkObj.clickEvent)
        }
    }
}
// apps flyer
extension AppDelegate: AppsFlyerLibDelegate {
    // 첫 설치 시 앱 설치 경로 분석
    // Handle Organic/Non-organic installation
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        ConversionData = data
        print("onConversionDataSuccess data:")
        for (key, value) in data {
            print(key, ":", value)
        }
        if let conversionData = data as NSDictionary? as! [String:Any]? {
            
            if let status = conversionData["af_status"] as? String {
                if (status == "Non-organic") {
                    if let sourceID = conversionData["media_source"], //floney_share
                       let campaign = conversionData["campaign"] {
                        NSLog("[AFSDK] This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                    }
                } else {
                    NSLog("[AFSDK] This is an organic install.")
                }
                
                if let is_first_launch = conversionData["is_first_launch"] as? Bool,
                   is_first_launch {
                    NSLog("[AFSDK] First Launch")
                    if (deferred_deep_link_processed_flag == true) {
                        NSLog("Deferred deep link was already processed by UDL. The DDL processing in GCD can be skipped.")
                        deferred_deep_link_processed_flag = false
                        return
                    }
                    
                    deferred_deep_link_processed_flag = true
                    
                    var inviteCode:String
                    
                    if conversionData.keys.contains("deep_link_value") {
                        inviteCode = conversionData["deep_link_value"] as! String
                    } else if conversionData.keys.contains("fruit_name") {
                        inviteCode = conversionData["inviteCode"] as! String
                    } else {
                        NSLog("Could not extract deep_link_value or invite code from deep link object using conversion data")
                        return
                    }
                    
                    NSLog("This is a deferred deep link opened using conversion data")
                    walkToSceneWithParams(inviteCode: inviteCode, deepLinkData: conversionData)
                } else {
                    NSLog("[AFSDK] Not First Launch")
                }
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        NSLog("[AFSDK] \(error)")
    }
}

//MARK: FCM
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
    -> UIBackgroundFetchResult {
        print(userInfo)
        AppsFlyerLib.shared().handlePushNotification(userInfo)
        
        return UIBackgroundFetchResult.newData
    }
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken;
    }
}
