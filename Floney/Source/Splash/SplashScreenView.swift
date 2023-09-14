//
//  SplashScreenView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/02.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    @State private var isActive = false
    @StateObject var userSession = AuthenticationService.shared
    @StateObject var bookManager = BookExistenceViewModel.shared
    @StateObject var applinkManager = AppLinkManager.shared
    @ObservedObject var loadingManager = LoadingManager.shared
    @ObservedObject var alertManager = AlertManager.shared
    
    var body: some View {
        if isActive {
            ZStack {
                Group {
                    if !hasSeenOnboarding {
                        OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    } else {
                        // 로그인 된 경우
                        if userSession.isUserLoggedIn {
                            // 초대 링크로 들어온 경우
                            if applinkManager.hasDeepLink {
                                if applinkManager.inviteStatus {
                                    InviteBookView()
                                } else {
                                    if let settlementId = applinkManager.settlementId {
                                        MainTabView(selection : 3, settlementId:
                                                        settlementId,showingSettlementList: true, showingSettlementDetail: true)
                                    }
                                }
                            } else {
                                if bookManager.bookExistence {
                                    MainTabView()
                                } else {
                                    WelcomeView()
                                }
                            }
                            // 로그인 되지 않은 경우
                        } else {
                            SignInView()
                        }
                    }
                }
                if loadingManager.showLoadingForSubscribe {
                    ZStack {
                        Image("splash_bg")
                            .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                            .ignoresSafeArea()
                        //Image("splash_logo")
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .scaleEffect(2.0)
                    }
                }
                if AlertManager.shared.showAlert {
                    CustomAlertView(message: alertManager.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
                }
            }
        } else {
            ZStack {
                Image("splash_bg")
                    .resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                    .ignoresSafeArea()
                Image("splash_logo")
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                   
                }
                
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
