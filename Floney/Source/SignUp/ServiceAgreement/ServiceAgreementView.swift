//
//  ServiceAgreementView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/07.
//

import SwiftUI


struct ServiceAgreementView: View {
    let scaler = Scaler.shared
    var pageCount = 1
    var pageCountAll = 4
    @StateObject private var viewModel = ServiceAgreementViewModel()
    @StateObject var signupViewModel = SignUpViewModel()
    @State var isActive = false
    var body: some View {
        ZStack {
            VStack(spacing: scaler.scaleHeight(32)) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                    Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        Text("약관 동의")
                            .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                    }
                    Spacer()
                }
                VStack(spacing: 0) {
                    ServiceAgreementButton(isAgreed: $viewModel.isAllAgreed, checkboxType: "all", forwardButton: false, title: "전체 동의")
                    Divider()
                        .foregroundColor(.greyScale10)
                        .padding(0)
                    ServiceAgreementButton(isAgreed: $viewModel.isTerm1Agreed, title: "서비스 이용 약관 (필수)")
                    ServiceAgreementButton(isAgreed: $viewModel.isTerm2Agreed, title: "개인정보 수집 및 이용 동의 (필수)")
                    ServiceAgreementButton(isAgreed: $viewModel.isMarketingAgreed, title: "마케팅 정보 수신 동의 (선택)")
                    ServiceAgreementButton(isAgreed: $viewModel.isTerm3Agreed, forwardButton: false, title: "만 14세 이상 확인 (필수)")
                }
                Spacer()
                
                if signupViewModel.providerStatus != .email {
                    NavigationLink(destination: UserInfoView(viewModel: signupViewModel), isActive: $signupViewModel.isNextToEmailAuth){
                        Text("다음으로")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                            .onTapGesture {
                                if self.viewModel.isTerm1Agreed && self.viewModel.isTerm2Agreed && self.viewModel.isTerm3Agreed {
                                    // Navigate to the next screen
                                    signupViewModel.isNextToEmailAuth = true
                                    signupViewModel.marketingAgree = self.viewModel.isMarketingAgreed
                                } else {
                                    self.viewModel.showAlert = true
                                }
                            }
                        
                    }
                } else {
                    NavigationLink(destination: EmailAuthView(viewModel: signupViewModel), isActive: $signupViewModel.isNextToEmailAuth){
                        Text("다음으로")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                            .onTapGesture {
                                if self.viewModel.isTerm1Agreed && self.viewModel.isTerm2Agreed && self.viewModel.isTerm3Agreed  {
                                    // Navigate to the next screen
                                    signupViewModel.isNextToEmailAuth = true
                                    signupViewModel.marketingAgree = self.viewModel.isMarketingAgreed
                                } else {
                                    self.viewModel.showAlert = true
                                }
                            }
                    }
                }
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(32), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(38), trailing: scaler.scaleWidth(24)))
            .customNavigationBar(
                leftView: { BackButton() }
                )
            
            CustomAlertView(message: ErrorMessage.signup01.value, type: $viewModel.buttonType, isPresented: $viewModel.showAlert)
        } //ZStack
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ServiceAgreementButton: View {
    let scaler = Scaler.shared
    @Binding var isAgreed: Bool
    @State var checkboxType: String = "term"
    @State var forwardButton : Bool = true
    let title: String

    var body: some View {
        Button(action: {
            isAgreed.toggle()
        }) {
            HStack(spacing: scaler.scaleWidth(14)) {
                if checkboxType == "term" {
                    Image(isAgreed ? "check_primary" : "checkbox_grey")
                } else if checkboxType == "all" {
                    Image(isAgreed ? "check_primary" : "checkbox_primary")
                }
                    
                Text(title)
                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                    .foregroundColor(.greyScale2)
                Spacer()
                if forwardButton {
                    Image("forward_button")
                }
            }
        }
        .frame(height: scaler.scaleHeight(50))
        .frame(maxWidth: .infinity)
    }
}


struct ServiceAgreementView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceAgreementView()
    }
}
