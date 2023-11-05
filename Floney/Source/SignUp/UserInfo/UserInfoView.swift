//
//  SignUpView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct UserInfoView: View {
    let scaler = Scaler.shared
    var pageCount = 4
    var pageCountAll = 4
    var email = "rrrrrkkkkrr@naver.com"
   
    @ObservedObject var viewModel : SignUpViewModel
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
                        
                        
                        Text("가입 정보 입력")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                    }
                    Spacer()
                }
                VStack(spacing: scaler.scaleWidth(20)) {
                    VStack(alignment:.leading, spacing: scaler.scaleHeight(12)) {
                        HStack {
                            Text("이메일 주소")
                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }
                       
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: scaler.scaleHeight(46))
                            .frame(width: scaler.scaleWidth(320))
                            .background(Color.greyScale12)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.greyScale10, lineWidth: 1)
                            )
                            .overlay(
                                HStack {
                                    Text("\(email)")
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale2)
                                        .padding(.leading, scaler.scaleWidth(20))
                                    Spacer()
                                }
                                
                            )
                        
                        
                    }
                    if viewModel.providerStatus == .email {
                        VStack(spacing: scaler.scaleHeight(12)) {
                            HStack {
                                Text("비밀번호")
                                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                            
                            CustomTextField(text: $viewModel.password, placeholder: "비밀번호",isSecure: true, placeholderColor: .greyScale6)
                                .frame(height: scaler.scaleHeight(46))
                                .frame(width: scaler.scaleWidth(320))
                        }
                        VStack(spacing: scaler.scaleHeight(12)) {
                            HStack {
                                Text("비밀번호 확인")
                                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                            CustomTextField(text: $viewModel.passwordCheck, placeholder: "비밀번호 확인",isSecure: true, placeholderColor: .greyScale6)
                                .frame(height: scaler.scaleHeight(46))
                                .frame(width: scaler.scaleWidth(320))
                            HStack {
                                Text("* 영문, 숫자, 특수문자 포함 8자 이상")
                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                            .padding(.top, scaler.scaleHeight(2))
                            
                        }
                    }
                }
                VStack(spacing: scaler.scaleHeight(12)) {
                    HStack {
                        Text("닉네임")
                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale6)
                        Spacer()
                    }
                    CustomTextField(text: $viewModel.nickname, placeholder: viewModel.nickname.isEmpty ? "닉네임을 입력하세요" : viewModel.nickname, placeholderColor: .greyScale6)
                        .frame(height: scaler.scaleHeight(46))
                        .frame(width: scaler.scaleWidth(320))
                    HStack {
                        Text("* 최대 8자까지")
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale6)
                        Spacer()
                    }
                    .padding(.top, scaler.scaleHeight(2))

                }
                .padding(.top, scaler.scaleHeight(8))
                Spacer()
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        // 모든 유효성 검사에서 통과할 때, post함.
                        if viewModel.validateFields() {
                            switch viewModel.providerStatus {
                            case .email :
                                viewModel.postSignUp()
                            case .kakao :
                                viewModel.kakaoSignUp()
                            case .google :
                                viewModel.googleSignUp()
                            case .apple :
                                viewModel.appleSignUp()
                            }
                        }
                    }
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(32), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(38), trailing: scaler.scaleWidth(24)))
            .customNavigationBar(
                leftView: { BackButton() }
                )
            .edgesIgnoringSafeArea(.bottom)
            
        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        
    }
    
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(viewModel: SignUpViewModel())
    }
}
