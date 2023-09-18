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
    @StateObject var userSession = AuthenticationService.shared // 로그인 매니저
    @StateObject var bookManager = BookExistenceViewModel.shared // 유효 가계부 체크
    @StateObject var applinkManager = AppLinkManager.shared // 링크 매니저
    @ObservedObject var loadingManager = LoadingManager.shared // 로딩 매니저
    @ObservedObject var alertManager = AlertManager.shared // 알러트 매니저
    
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
                                                        settlementId,showingSettlementList: true, showingSettlementDetail: true)
                                    }
                                }
                            } else {
                                // 가계부 삭제, 가계부 나가기 실행 시 bookManager를 한 번 더 호출해야 함.
                                // 구독 해지 시 해당 가계부의 유효성을 다시 한번 체크해야 함?
                                if bookManager.bookExistence { // 가계부가 있을 때
                                    // MARK: 메인 화면
                                    MainTabView()
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
