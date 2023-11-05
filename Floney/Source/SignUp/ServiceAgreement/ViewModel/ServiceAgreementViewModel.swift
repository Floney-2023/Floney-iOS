//
//  ServiceAgreementViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//
import SwiftUI
import Combine

/*
class ServiceAgreementViewModel: ObservableObject {
    @Published var buttonType : ButtonType = .red
    @Published var showAlert: Bool = false
    @Published var isTerm1Agreed: Bool = false {
        willSet {
            if  newValue == true && newValue != isTerm1Agreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }
    
    @Published var isTerm2Agreed: Bool = false {
        willSet {
            if  newValue == true && newValue != isTerm2Agreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }
    
    @Published var isMarketingAgreed: Bool = false {
        willSet {
            if  newValue == true && newValue != isMarketingAgreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }

    
    @Published var isTerm3Agreed: Bool = false {
        willSet {
            if newValue == true && newValue != isTerm3Agreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }
    @Published var isAllAgreed: Bool = false {
        willSet {
            if newValue == false && newValue != isAllAgreed {
                isTerm1Agreed = newValue
                isTerm2Agreed = newValue
                isTerm3Agreed = newValue
                isMarketingAgreed = newValue
            } else if newValue == true {
                isTerm1Agreed = newValue
                isTerm2Agreed = newValue
                isTerm3Agreed = newValue
                isMarketingAgreed = newValue 
            }
        }
    }
    
}

*/
class ServiceAgreementViewModel: ObservableObject {
    @Published var buttonType : ButtonType = .red
    @Published var showAlert: Bool = false
    
    @Published var isTerm1Agreed: Bool = false
    @Published var isTerm2Agreed: Bool = false
    @Published var isMarketingAgreed: Bool = false
    @Published var isTerm3Agreed: Bool = false
    @Published var isAllAgreed: Bool = false {
        didSet {
            if isAllAgreed {
                setAllAgreed(to: true)
            } else if oldValue == true && !isAllAgreed {
                // This is necessary to handle the user manually deselecting "all agreed".
                setAllAgreed(to: false)
            }
        }
    }

    init() {
        // Subscribe to changes in individual agreement variables
        $isTerm1Agreed
            .combineLatest($isTerm2Agreed, $isTerm3Agreed, $isMarketingAgreed)
            .map { term1, term2, term3, marketing in
                // Return true only if all individual agreements are true
                term1 && term2 && term3 && marketing
            }
            .assign(to: &$isAllAgreed)
    }

    // Function to call when "All Agreed" toggle is changed
    func setAllAgreed(to value: Bool) {
        // This will update all individual agreements and isAllAgreed because of the combineLatest subscription
        isTerm1Agreed = value
        isTerm2Agreed = value
        isTerm3Agreed = value
        isMarketingAgreed = value
    }
    // No need for individual functions for each agreement, since combineLatest will handle the logic
}
