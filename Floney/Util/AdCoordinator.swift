//
//  GADInterstitialView.swift
//  Floney
//
//  Created by 남경민 on 2/21/24.
//

import SwiftUI
import UIKit
import GoogleMobileAds


class AdCoordinator: NSObject, GADFullScreenContentDelegate {
    var interstitial: GADInterstitialAd?
    var pageType: String?
    var onAdDismiss: (() -> Void)?
    
    init(pageType: String?) {
        super.init()
        self.pageType = pageType
        loadInterstitialAd()
    }
    private func loadInterstitialAd() {
        let request = GADRequest()
        var adUnitID: String = "ca-app-pub-3940256099942544/5135589807"
        
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func showAd() {
        guard let fullScreenAd = interstitial else {
            return print("Ad wasn't ready")
        }
        // View controller is an optional parameter. Pass in nil.
        fullScreenAd.present(fromRootViewController: nil)
    }
    func saveAdWatchTime() {
        let currentTime = Date()
        if pageType == "HOME" {
            UserDefaults.standard.set(currentTime, forKey: "lastHomeAdWatchTime")
        } else if pageType == "SETTLEMENT" {
            UserDefaults.standard.set(currentTime, forKey: "lastSettlementAdWatchTime")
        }
    }
    func canShowHomeAd() -> Bool {
        guard let lastAdWatchTime = UserDefaults.standard.object(forKey: "lastHomeAdWatchTime") as? Date else {
            // 광고 시청 기록이 없는 경우
            return true
        }
        
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(lastAdWatchTime)
        return elapsedTime >= 600
    }
    func canShowSettlementAd() -> Bool {
        guard let lastAdWatchTime = UserDefaults.standard.object(forKey: "lastSettlementAdWatchTime") as? Date else {
            // 광고 시청 기록이 없는 경우
            return true
        }
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(lastAdWatchTime)
        return elapsedTime >= 600
    }

    
    // MARK: - GADFullScreenContentDelegate methods
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
        self.saveAdWatchTime()
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
        
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
        onAdDismiss?() // 광고가 닫힐 때 콜백 호출
        loadInterstitialAd() // 광고를 다시 로드
    }
}

class RewardedAdCoordinator: NSObject, GADFullScreenContentDelegate {
    private var rewardedAd: GADRewardedAd?
    var onAdDismiss: (() -> Void)?
    
    override init() {
        super.init()
        loadInterstitialAd()
    }
    private func loadInterstitialAd() {
        let request = GADRequest()
        var adUnitID: String = "ca-app-pub-3940256099942544/1712485313"
        
        GADRewardedAd.load(withAdUnitID: adUnitID, request: request) { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    
    func showAd() {
        guard let fullScreenAd = rewardedAd else {
            return print("Ad wasn't ready")
        }
        
        // View controller is an optional parameter. Pass in nil.
        fullScreenAd.present(fromRootViewController: nil) {
            self.saveAdWatchTime()
        }
    }
    
    func saveAdWatchTime() {
        let currentTime = Date()
        UserDefaults.standard.set(currentTime, forKey: "lastAdWatchTime")
    }
    
    func canShowAd() -> Bool {
        guard let lastAdWatchTime = UserDefaults.standard.object(forKey: "lastAdWatchTime") as? Date else {
            // 광고 시청 기록이 없는 경우
            return true
        }
        
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(lastAdWatchTime)
        // 6시간(21600초)이 경과했는지 확인
        return elapsedTime >= 21600
    }
    
    // MARK: - GADFullScreenContentDelegate methods
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("\(#function) called")
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
        onAdDismiss?() // 광고가 닫힐 때 콜백 호출
        loadInterstitialAd() // 광고를 다시 로드
    }
}

