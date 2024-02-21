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
    var onAdDismiss: (() -> Void)?
    
    override init() {
        super.init()
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
