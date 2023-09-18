//
//  ChangePasswordView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/22.
//

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel = MyPageViewModel()
    var body: some View {
        ZStack {
            VStack(spacing:30) {
                VStack(spacing:12) {
                    HStack {
                        Text("현재 비밀번호")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    CustomTextField(text: $viewModel.currentPassword, placeholder: "현재 비밀번호를 입력하세요.",placeholderColor: .greyScale7)
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                }
                
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("새 비밀번호")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        CustomTextField(text: $viewModel.newPassword, placeholder: "영문 대소문자, 숫자 포함 8자 이상",placeholderColor: .greyScale7)
                            .frame(height: UIScreen.main.bounds.height * 0.06)
                    }
                    VStack(spacing: 12) {
                        HStack {
                            Text("새 비밀번호 확인")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        CustomTextField(text: $viewModel.newPasswordCheck, placeholder: "영문 대소문자, 숫자 포함 8자 이상",placeholderColor: .greyScale7)
                            .frame(height: UIScreen.main.bounds.height * 0.06)
                    }
                }
                
                Text("확인")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        if viewModel.isValidInputs() {
                            viewModel.changePassword()
                        }
                    }
                Spacer()
                
            }
            .padding(EdgeInsets(top: 35, leading: 20, bottom: 0, trailing: 20))
            .customNavigationBar(
                leftView: { BackButtonBlack() },
                centerView: { Text("비밀번호 변경")
                        .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)}
                
                )
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
