//
//  SignInView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/03.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import GoogleSignIn

struct SignInView: View {
    @StateObject var signInViewModel = SignInViewModel()
    @StateObject var signUpViewModel = SignUpViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing:50) {
                    Image("logo_floney_signin")
                        .padding(EdgeInsets(top: 128, leading: 0, bottom: 0, trailing: 0))
                    
                    VStack(spacing: 20) {

                        CustomTextField(text: $signInViewModel.email, placeholder: "이메일", keyboardType: .emailAddress,placeholderColor: .greyScale7)
                            .frame(height: UIScreen.main.bounds.height * 0.06)
                            
    
                        CustomTextField(text: $signInViewModel.password, placeholder: "비밀번호", isSecure: true,placeholderColor: .greyScale7)
                            .frame(height: UIScreen.main.bounds.height * 0.06)
                       

                        Text("로그인 하기")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                            .onTapGesture {
                                signInViewModel.postSignIn()
                            }

                        HStack(spacing:50) {
                            NavigationLink(destination: FindPasswordView()){
                                VStack {
                                    Text("비밀번호 찾기")
                                        .font(.pretendardFont(.regular, size: 12))
                                        .foregroundColor(.greyScale6)
                                    
                                    
                                    Divider()
                                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                        .frame(width: 70,height: 1.0)
                                        .foregroundColor(.greyScale6)
                                }
                            }

                            NavigationLink(destination: signInViewModel.providerStatus != .email ? ServiceAgreementView(signupViewModel: SignUpViewModel(email: signInViewModel.email, authToken: signInViewModel.authToken, nickname: signInViewModel.nickname, providerStatus: signInViewModel.providerStatus)) : ServiceAgreementView(), isActive: $signInViewModel.isNextToServiceAgreement){
                                VStack {
                                    Text("회원가입 하기")
                                        .font(.pretendardFont(.regular, size: 12))
                                        .foregroundColor(.greyScale6)
                                    Divider()
                                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                        .frame(width: 70,height: 1.0)
                                        .foregroundColor(.greyScale6)
                                    
                                }
                                .onTapGesture {
                                    signInViewModel.providerStatus = .email
                                    signInViewModel.isNextToServiceAgreement = true
                                }
                            }
                        }
                    }
                    .padding(20)
                    VStack(spacing:20) {
                        Text("간편 로그인")
                            .font(.pretendardFont(.medium,size: 12))
                        HStack(spacing:30) {
                            Image("btn_kakao")
                                .onTapGesture {
                                    signInViewModel.performKakaoSignIn()
                                }
                            Image("btn_google")
                                .onTapGesture {
                                    Task {
                                        do {
                                            try await signInViewModel.signInGoogle()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            Image("btn_apple")
                                .onTapGesture {
                                    signInViewModel.performAppleSignIn()
                                }
                        }
                    }
                    Spacer()
                }
                CustomAlertView(message: signInViewModel.errorMessage, type: $signInViewModel.buttonType, isPresented: $signInViewModel.showAlert)
                
            }
            .onAppear(perform : UIApplication.shared.hideKeyboard)
        }
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
