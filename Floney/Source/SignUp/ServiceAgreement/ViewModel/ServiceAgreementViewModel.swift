//
//  ServiceAgreementViewModel.swift
//  Floney
//
//  Created by 남경민 on 2023/05/08.
//
import SwiftUI
import Combine

class ServiceAgreementViewModel: ObservableObject {
    @Published var buttonType : ButtonType = .red
    @Published var showAlert: Bool = false
    @Published var isTerm1Agreed: Bool = false {
        willSet {
            if newValue != isTerm1Agreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }
    
    @Published var isTerm2Agreed: Bool = false {
        willSet {
            if newValue != isTerm2Agreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }
    
    @Published var isMarketingAgreed: Bool = false {
        willSet {
            if newValue != isMarketingAgreed {
                DispatchQueue.main.async {
                    self.isAllAgreed = self.isTerm1Agreed && self.isTerm2Agreed && self.isTerm3Agreed && self.isMarketingAgreed
                }
            }
        }
    }

    
    @Published var isTerm3Agreed: Bool = false {
        willSet {
            if newValue != isTerm3Agreed {
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
