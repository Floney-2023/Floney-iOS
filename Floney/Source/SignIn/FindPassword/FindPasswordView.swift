//
//  FindPasswordView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct FindPasswordView: View {
    let scaler = Scaler.shared
    @Binding var isShowing : Bool
    @Binding var email : String
    @StateObject var viewModel = SignInViewModel()
    @StateObject var alertManager = AlertManager.shared
    @ObservedObject var loadingManager = LoadingManager.shared
    var body: some View {
        ZStack {
            VStack(spacing: scaler.scaleHeight(32)) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        Text("비밀번호 찾기")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                        Text("비밀번호를 찾으려면\n가입한 이메일 주소를 입력하세요.")
                            .lineSpacing(4)
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                VStack(spacing: scaler.scaleHeight(20)) {
                    CustomTextField(text: $email, placeholder: "이메일을 입력하세요.", keyboardType: .emailAddress,placeholderColor: .greyScale6)
                        .frame(height: scaler.scaleHeight(46))
                    
                    Text("임시 비밀번호 보내기")
                        .padding()
                        .withNextButtonFormmating(.primary1)
                        .onTapGesture {
                            if viewModel.checkValidation(email: email) {
                                LoadingManager.shared.update(showLoading: true, loadingType: .floneyLoading)
                                viewModel.findPassword(email: email)
                            }
                        }
                }
                Spacer()
            }
            .padding(EdgeInsets(top: scaler.scaleHeight(52), leading: scaler.scaleWidth(24), bottom: 0, trailing: scaler.scaleWidth(24)))
            .customNavigationBar(
                leftView: { BackButton() }
                )
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            
            if AlertManager.shared.showAlert {
                CustomAlertView(message: AlertManager.shared.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
            }
            
            PasswordBottomSheet(isShowing: $viewModel.isShowingBottomSheet, isShowingFindPassword: $isShowing)
            

        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}
