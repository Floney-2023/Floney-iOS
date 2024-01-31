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
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // test Key
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
    }
}
