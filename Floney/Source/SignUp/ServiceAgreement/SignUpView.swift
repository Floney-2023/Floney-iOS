//
//  SignUpView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct SignUpView: View {
    var pageCount = 2
    var pageCountAll = 3
    @State var email = ""
    @State var password = ""
    @State var passwordCheck = ""
    @State var nickname = ""
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                        
                        Text("가입 정보 입력")
                            .font(.pretendardFont(.bold, size: 24))
                            .foregroundColor(.greyScale1)
                    }
                    Spacer()
                }
                VStack(spacing: 20) {
                    VStack(spacing: 14) {
                        HStack {
                            Text("이메일 주소")
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
                        
                        TextField("", text: $email)
                            .padding()
                            .keyboardType(.emailAddress)
                            .overlay(
                                Text("이메일")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale6)
                                    .opacity(email.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                    }
                    VStack(spacing: 14) {
                        HStack {
                            Text("비밀번호")
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
                        
                        TextField("", text: $password)
                            .padding()
                            .overlay(
                                Text("비밀번호")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale6)
                                    .opacity(password.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                        
                    }
                    VStack(spacing: 14) {
                        HStack {
                            Text("비밀번호 확인")
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
                        
                        TextField("", text: $passwordCheck)
                            .padding()
                            .overlay(
                                Text("비밀번호 확인")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale6)
                                    .opacity(passwordCheck.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                        
                        HStack {
                            Text("* 영문, 숫자, 특수문자 포함 8자 이상")
                                .font(.pretendardFont(.regular, size: 12))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
                        
                    }
                }
                VStack(spacing: 14) {
                    HStack {
                        Text("닉네임")
                            .font(.pretendardFont(.semiBold, size: 14))
                            .foregroundColor(.greyScale6)
                        Spacer()
                    }
                    
                    TextField("", text: $nickname)
                        .padding()
                        .keyboardType(.emailAddress)
                        .overlay(
                            Text("닉네임을 입력하세요.")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale6)
                                .opacity(nickname.isEmpty ? 1 : 0), alignment: .leading
                        )
                        .modifier(TextFieldModifier())
                }
                Spacer()
                
                NavigationLink(destination: WelcomeView()){
                    Text("다음으로")
                        .padding()
                        .modifier(NextButtonModifier())
                }
            }
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
        }
        .onTapGesture {
            // Hide the keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            // Set the TextField as the first responder
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.rootViewController?.view.endEditing(false)
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
