//
//  ChangePasswordView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/22.
//

import SwiftUI

struct ChangePasswordView: View {
    @State var password = ""
    @State var newPassword = ""
    @State var newPasswordCheck = ""
    var body: some View {
        VStack(spacing:30) {
            VStack(spacing:12) {
                HStack {
                    Text("현재 비밀번호")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }
                
                TextField("", text: $password)
                    .padding()
                    .overlay(
                        Text("현재 비밀번호를 입력하세요.")
                            .padding()
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale7)
                            .opacity(password.isEmpty ? 1 : 0), alignment: .leading
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
                    
                    TextField("", text: $newPassword)
                        .padding()
                        .overlay(
                            Text("영문 대소문자, 숫자 포함 8자 이상")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale7)
                                .opacity(newPassword.isEmpty ? 1 : 0), alignment: .leading
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
                    
                    TextField("", text: $newPasswordCheck)
                        .padding()
                        .overlay(
                            Text("영문 대소문자, 숫자 포함 8자 이상")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale7)
                                .opacity(newPasswordCheck.isEmpty ? 1 : 0), alignment: .leading
                        )
                        .modifier(TextFieldModifier())
                    
                }
            }
            NavigationLink(destination: WelcomeView()){
                Text("확인")
                    .padding()
                    .withNextButtonFormmating(.primary1)
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
        
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
