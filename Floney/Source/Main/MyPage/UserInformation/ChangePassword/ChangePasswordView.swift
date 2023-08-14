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
                    
                    TextField("", text: $viewModel.currentPassword)
                        .padding()
                        .overlay(
                            Text("현재 비밀번호를 입력하세요.")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale7)
                                .opacity(viewModel.currentPassword.isEmpty ? 1 : 0), alignment: .leading
                        )
                        .modifier(TextFieldModifier())
                }
                
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        HStack {
                            Text("새 비밀번호")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        TextField("", text: $viewModel.newPassword)
                            .padding()
                            .overlay(
                                Text("영문 대소문자, 숫자 포함 8자 이상")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale7)
                                    .opacity(viewModel.newPassword.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                        
                    }
                    VStack(spacing: 12) {
                        HStack {
                            Text("새 비밀번호 확인")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        
                        TextField("", text: $viewModel.newPasswordCheck)
                            .padding()
                            .overlay(
                                Text("영문 대소문자, 숫자 포함 8자 이상")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale7)
                                    .opacity(viewModel.newPasswordCheck.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButtonBlack())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("비밀번호 변경")
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale1)
                }
            }
            if viewModel.showAlert {
                CustomAlertView(message: viewModel.errorMessage, isPresented: $viewModel.showAlert)
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
