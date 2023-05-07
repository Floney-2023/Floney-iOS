//
//  ServiceAgreementViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//
import SwiftUI
import Combine

class ServiceAgreementViewModel: ObservableObject {
    @StateObject var signupViewModel = SignUpViewModel()
    @Published var isTerm1Agreed: Bool = false {
        didSet {
            updateAllAgreed()
        }
    }
    @Published var isTerm2Agreed: Bool = false {
        didSet {
            updateAllAgreed()
        }
    }
    @Published var isTerm3Agreed: Bool = false {
        didSet {
            updateAllAgreed()
        }
    }
    
    @Published var isOptionalTermAgreed: Bool = false {
        didSet {
            if self.isOptionalTermAgreed {
                signupViewModel.marketingAgree = 1
            } else {
                signupViewModel.marketingAgree = 0
            }
        }
    }
    
    @Published var isAllAgreed: Bool = false {
        didSet {
            if isAllAgreed {
                isTerm1Agreed = true
                isTerm2Agreed = true
                isTerm3Agreed = true
                isOptionalTermAgreed = true
            }
        }
    }

    private func updateAllAgreed() {
        isAllAgreed = isTerm1Agreed && isTerm2Agreed
                    && isTerm3Agreed && isOptionalTermAgreed
    }
}
