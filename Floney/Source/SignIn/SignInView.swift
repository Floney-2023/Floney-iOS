//
//  SignInView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import SwiftUI


struct SignInView: View {
    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack(spacing:50) {
            Image("logo_floney_signin")
                
                .padding(EdgeInsets(top: 128, leading: 0, bottom: 0, trailing: 0))
            
            VStack(spacing: 20) {
                TextField("이메일", text: $email)
                    .padding()
                    .font(.pretendardFont(.regular, size: 14))
                    .foregroundColor(.greyScale7)
                    .background(Color.greyScale12)
                    .border(Color.greyScale10)
                    .cornerRadius(12)
                    .keyboardType(.emailAddress)
                
                TextField("비밀번호", text: $password)
                    .padding()
                    .font(.pretendardFont(.regular, size: 14))
                    .foregroundColor(.greyScale7)
                    .background(Color.greyScale12)
                    .border(Color.greyScale10)
                    .cornerRadius(12)
                
                Button("로그인 하기") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                .padding()
                .font(.pretendardFont(.bold, size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.primary1)
                .cornerRadius(12)
                
                HStack(spacing:50) {
                    VStack {
                        
                        Button("비밀번호 찾기") {
                            
                        }
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale6)
                        
                        
                        Divider()
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: 70,height: 1.0)
                            .foregroundColor(.greyScale6)
                        
                    }
                    
                    VStack {
                        Button("회원가입 하기") {
                            
                        }
                        
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale6)
                        Divider()
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: 70,height: 1.0)
                            .foregroundColor(.greyScale6)
                        
                    }
                }
            }
            .padding(20)
            VStack(spacing:20) {
                Text("간편 로그인")
                    .font(.pretendardFont(.medium,size: 12))
                HStack(spacing:30) {
                    Image("kakao_signin")
                    Image("apple_signin")
                    Image("google_signin")
                    
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
