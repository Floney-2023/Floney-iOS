//
//  SignUpView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct UserInfoView: View {
    var pageCount = 4
    var pageCountAll = 4
   
    @ObservedObject var viewModel : SignUpViewModel
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
                       
                        Text("\(viewModel.email)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale2)
                            .background(Color.greyScale12)
                            .cornerRadius(12)
                        //.border(Color.greyScale10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.greyScale10, lineWidth: 1) // Set the border
                            )
                        
                    }
                    if viewModel.providerStatus == .email {
                        VStack(spacing: 14) {
                            HStack {
                                Text("비밀번호")
                                    .font(.pretendardFont(.semiBold, size: 14))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                            
                            CustomTextField(text: $viewModel.password, placeholder: "비밀번호",isSecure: true, placeholderColor: .greyScale6)
                                .frame(height: UIScreen.main.bounds.height * 0.06)
                            
                            
                        }
                        VStack(spacing: 14) {
                            HStack {
                                Text("비밀번호 확인")
                                    .font(.pretendardFont(.semiBold, size: 14))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                            CustomTextField(text: $viewModel.passwordCheck, placeholder: "비밀번호 확인",isSecure: true, placeholderColor: .greyScale6)
                                .frame(height: UIScreen.main.bounds.height * 0.06)
                            
                            
                            HStack {
                                Text("* 영문, 숫자, 특수문자 포함 8자 이상")
                                    .font(.pretendardFont(.regular, size: 12))
                                    .foregroundColor(.greyScale6)
                                Spacer()
                            }
                            
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
                    CustomTextField(text: $viewModel.nickname, placeholder: viewModel.nickname.isEmpty ? "닉네임을 입력하세요" : viewModel.nickname, placeholderColor: .greyScale6)
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                }
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
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
        }
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
    
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(viewModel: SignUpViewModel())
    }
}
