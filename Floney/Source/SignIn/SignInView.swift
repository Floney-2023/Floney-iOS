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
    var scaler = Scaler.shared
    @StateObject var signInViewModel = SignInViewModel()
    @StateObject var signUpViewModel = SignUpViewModel()
    @State var isShowingFindPassword = false
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing:scaler.scaleWidth(44)) {
                    Image("logo_floney_signin")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:scaler.scaleWidth(106), height: scaler.scaleHeight(26))
                        .padding(EdgeInsets(top: scaler.scaleHeight(86), leading: 0, bottom: 0, trailing: 0))
                    
                    VStack(spacing: scaler.scaleHeight(20)) {
                        CustomTextField(text: $signInViewModel.email, placeholder: "이메일", keyboardType: .emailAddress,placeholderColor: .greyScale7)
                            .frame(width: scaler.scaleWidth(320), height: scaler.scaleHeight(46))
                            .frame(maxWidth: scaler.scaleWidth(320))
                        
                        CustomTextField(text: $signInViewModel.password, placeholder: "비밀번호", isSecure: true,placeholderColor: .greyScale7)
                            .frame(width: scaler.scaleWidth(320), height: scaler.scaleHeight(46))
                            .frame(maxWidth: scaler.scaleWidth(320))
                        
                        Text("로그인하기")
                            .padding(scaler.scaleHeight(16))
                            .withNextButtonFormmating(.primary1)
                            .onTapGesture {
                                signInViewModel.postSignIn()
                            }

                        HStack(spacing:scaler.scaleWidth(76)) {
                            NavigationLink(destination: FindPasswordView(isShowing: $isShowingFindPassword, email: $signInViewModel.email), isActive: $isShowingFindPassword){
                                VStack(spacing:0) {
                                    Text("비밀번호 찾기")
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale6)
                                    Rectangle()
                                      .foregroundColor(.clear)
                                      .frame(width: scaler.scaleWidth(66), height: scaler.scaleWidth(0.7))
                                      .background(Color.greyScale6)
                                }
                                .onTapGesture {
                                    isShowingFindPassword = true
                                }
                            }

                            NavigationLink(destination: signInViewModel.providerStatus != .email ? ServiceAgreementView(signupViewModel: SignUpViewModel(email: signInViewModel.email, authToken: signInViewModel.authToken, nickname: signInViewModel.nickname, providerStatus: signInViewModel.providerStatus)) : ServiceAgreementView(), isActive: $signInViewModel.isNextToServiceAgreement){
                                VStack(spacing:0) {
                                    Text("회원가입 하기")
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale6)
                                    Rectangle()
                                      .foregroundColor(.clear)
                                      .frame(width: scaler.scaleWidth(66), height: scaler.scaleWidth(0.7))
                                      .background(Color.greyScale6)
                                    
                                }
                                .onTapGesture {
                                    signInViewModel.providerStatus = .email
                                    signInViewModel.isNextToServiceAgreement = true
                                }
                            }
                        }.padding(.top,scaler.scaleHeight(8))
                    }
                    .padding(.horizontal,scaler.scaleWidth(20))
                    
                    VStack(spacing:scaler.scaleHeight(20)) {
                        Text("간편 로그인")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(12)))
                        HStack(spacing:scaler.scaleWidth(34)) {
                            Image("btn_kakao")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:scaler.scaleWidth(48), height: scaler.scaleWidth(48))
                         
                                .onTapGesture {
                                    signInViewModel.performKakaoSignIn()
                                }
                            Image("btn_google")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:scaler.scaleWidth(48), height: scaler.scaleWidth(48))
                            
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
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:scaler.scaleWidth(48), height: scaler.scaleWidth(48))
                           
                                .onTapGesture {
                                    signInViewModel.performAppleSignIn()
                                }
                        }
                    }.padding(.top,scaler.scaleHeight(21))
                    Spacer()
                }
                CustomAlertView(message: signInViewModel.errorMessage, type: $signInViewModel.buttonType, isPresented: $signInViewModel.showAlert)
            }
            .onAppear(perform : UIApplication.shared.hideKeyboard)
        }
        .navigationViewStyle(.stack)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
