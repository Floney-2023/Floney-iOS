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
    @ObservedObject var userSession = AuthenticationService.shared // 로그인 매니저
    @ObservedObject var bookManager = BookExistenceViewModel.shared // 유효 가계부 체크
    @ObservedObject var applinkManager = AppLinkManager.shared // 링크 매니저
    @ObservedObject var loadingManager = LoadingManager.shared // 로딩 매니저
    @ObservedObject var alertManager = AlertManager.shared // 알러트 매니저
    @ObservedObject var blackAlertManager = BlackAlertManager.shared // 알러트 매니저
    
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
                                // MARK: 사용자 가계부 초대 화면
                                if applinkManager.inviteStatus {
                                    InviteBookView()
                                } else {
                                    if let settlementId = applinkManager.settlementId {
                                        //MARK: 정산 영수증 화면
                                        MainTabView(selection : 3, settlementId:
                                                        settlementId, showingSettlementList: true, showingSettlementDetail: true)
                                    }
                                }
                            } else {
                                if bookManager.bookExistence { // 가계부가 있을 때
                                    // MARK: 메인 화면
                                    if userSession.newMainTab {
                                        MainTabView()
                                    } else {
                                        MainTabView()
                                    }
                                } else { // 가계부가 없을 때
                                    // MARK: Welcome View
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
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .scaleEffect(2.0)
                    }
                }
                // Loading view overlay
                if loadingManager.showLoading {
                    if loadingManager.loadingType == .floneyLoading {
                        LoadingView()
                    }
                    else if loadingManager.loadingType == .progressLoading{
                        ProgressLoadingView()
                    } else {
                        DimmedLoadingView()
                    }
                }
                
                if AlertManager.shared.showAlert {
                    CustomAlertView(message: alertManager.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
                }
                if BlackAlertManager.shared.showAlert {
                    BlackFloneyAlertView(isPresented: $blackAlertManager.showAlert, title: $blackAlertManager.title, message: $blackAlertManager.message)
                }
                if userSession.signoutStatus {
                    SuccessSignoutView()
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
