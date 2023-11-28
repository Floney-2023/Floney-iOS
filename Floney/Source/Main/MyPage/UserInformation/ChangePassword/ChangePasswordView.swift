//
//  ChangePasswordView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/22.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let scaler = Scaler.shared
    @StateObject var viewModel = MyPageViewModel()
    var body: some View {
        ZStack {
            VStack(spacing:scaler.scaleHeight(30)) {
                VStack(spacing:scaler.scaleHeight(12)) {
                    HStack {
                        Text("현재 비밀번호")
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale2)
                            .padding(.leading, scaler.scaleWidth(4))
                        Spacer()
                    }
                    CustomTextField(text: $viewModel.currentPassword, placeholder: "현재 비밀번호를 입력하세요.", isSecure: true, placeholderColor: .greyScale7)
                        .frame(height: scaler.scaleHeight(46))
                }
                
                VStack(spacing: scaler.scaleHeight(20)) {
                    VStack(spacing: scaler.scaleHeight(12)) {
                        HStack {
                            Text("새 비밀번호")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                                .padding(.leading, scaler.scaleWidth(4))
                            Spacer()
                        }
                        CustomTextField(text: $viewModel.newPassword, placeholder: "영문 대소문자, 숫자, 특수문자 포함 8자 이상", isSecure: true, placeholderColor: .greyScale7)
                            .frame(height: scaler.scaleHeight(46))
                    }
                    VStack(spacing: scaler.scaleHeight(12)) {
                        HStack {
                            Text("새 비밀번호 확인")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .padding(.leading, scaler.scaleWidth(4))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        CustomTextField(text: $viewModel.newPasswordCheck, placeholder: "영문 대소문자, 숫자, 특수문자 포함 8자 이상", isSecure: true, placeholderColor: .greyScale7)
                            .frame(height: scaler.scaleHeight(46))
                    }
                }
                
                Text("확인")
                    .padding(scaler.scaleWidth(20))
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        if viewModel.isValidInputs() {
                            viewModel.changePassword()
                        }
                    }
                Spacer()
            }
            .padding(EdgeInsets(top: scaler.scaleHeight(35), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
            .customNavigationBar(
                leftView: { BackButtonBlack() },
                centerView: { Text("비밀번호 변경")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)}
                
                )
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .onChange(of : viewModel.successChangePassword) { newValue in
                presentationMode.wrappedValue.dismiss()
            }
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
