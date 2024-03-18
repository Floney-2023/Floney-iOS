//
//  GADBanner.swift
//  Floney
//
//  Created by 남경민 on 1/31/24.
//

import SwiftUI
import UIKit
import GoogleMobileAds

struct GADBanner: UIViewControllerRepresentable {
#if DEBUG
    let adUnitID = "ca-app-pub-3940256099942544/2934735716"
#else
    let adUnitID = "ca-app-pub-8361265242086915/6243867737"
#endif
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let GADAdSizeBanner = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.size.width, height: 50))
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = adUnitID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator()
      }

      class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
          print("bannerViewDidReceiveAd")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
          print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
          print("bannerViewDidRecordImpression")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillPresentScreen")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewWillDIsmissScreen")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
          print("bannerViewDidDismissScreen")
        }
      }
}
