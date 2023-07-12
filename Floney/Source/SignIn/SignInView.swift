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
    @StateObject var viewModel = SignInViewModel()
    @StateObject var kakaoviewModel = SignUpViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing:50) {
                    Image("logo_floney_signin")
                        .padding(EdgeInsets(top: 128, leading: 0, bottom: 0, trailing: 0))
                    
                    VStack(spacing: 20) {
                        TextField("", text: $viewModel.email)
                            .padding()
                            .keyboardType(.emailAddress)
                            .overlay(
                                Text("이메일")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale7)
                                    .opacity(viewModel.email.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                        
                        
                        SecureField("", text: $viewModel.password)
                            .padding()
                            .overlay(
                                Text("비밀번호")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale7)
                                    .opacity(viewModel.password.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                        //NavigationLink(destination: MainTabView(), isActive: $viewModel.isNext){
                        Text("로그인 하기")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                        
                            .onTapGesture {
                                //let signInRequest = SignInRequest(email: email, password: password)
                                viewModel.postSignIn()
                            }
                        // }
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
                            //ServiceAgreementView()
                            NavigationLink(destination: ServiceAgreementView()){
                                VStack {
                                    Text("회원가입 하기")
                                        .font(.pretendardFont(.regular, size: 12))
                                        .foregroundColor(.greyScale6)
                                    Divider()
                                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                        .frame(width: 70,height: 1.0)
                                        .foregroundColor(.greyScale6)
                                    
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
                                    // view model에 저장해야 함.
                                    //카카오톡이 깔려있는지 확인하는 함수
                                    if (UserApi.isKakaoTalkLoginAvailable()) {
                                        //카카오톡이 설치되어있다면 카카오톡을 통한 로그인 진행
                                        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                                            if let error = error {
                                                print(error)
                                            }
                                            if let oauthToken = oauthToken{
                                                // 소셜 로그인(회원가입 API CALL)
                                                print("성공")
                                                
                                                UserApi.shared.me() {(user, error) in
                                                    if let error = error {
                                                        print(error)
                                                    }
                                                    else {
                                                        print("me() success.")
                                                        
                                                        let nickname = user?.kakaoAccount?.profile?.nickname
                                                        let email = user?.kakaoAccount?.email
                                                        
                                                        print("nickname : \(nickname)")
                                                        print("email : \(email)")
                                                        print("oauthToken : \(oauthToken)")
                                                        
                                                        viewModel.signUpViewModel.email = email!
                                                        viewModel.signUpViewModel.nickname = nickname!
                                                        //viewModel.signUpViewModel.provider = "kakao"
                                                        
                                                        let token = String(describing: oauthToken.accessToken)
                                                        viewModel.checkKakao(token: token)
                                                        // "is_email_valid" = 1;
                                                        // "is_email_verified" = 1;
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        //카카오톡이 설치되어있지 않다면 사파리를 통한 로그인 진행
                                        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                                            print(oauthToken?.accessToken)
                                            print(error)
                                        }
                                    }
                                }
                            //ios가 버전이 올라감에 따라 sceneDelegate를 더이상 사용하지 않게되었다
                            //그래서 로그인을 한후 리턴값을 인식을 하여야하는데 해당 코드를 적어주지않으면 리턴값을 인식되지않는다
                            //swiftUI로 바뀌면서 가장큰 차이점이다.
                                .onOpenURL(perform: { url in
                                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                                        _ = AuthController.handleOpenUrl(url: url)
                                    }
                                })
                            Image("btn_google")
                                .onTapGesture {
                                    Task {
                                        do {
                                            try await viewModel.signInGoogle()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            Image("btn_apple")
                        }
                    }
                    Spacer()
                }
                CustomAlertView(message: viewModel.errorMessage, isPresented: $viewModel.showAlert)
            }
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            /*
            .fullScreenCover(isPresented: $viewModel.isUserLoggedIn) {
                MainTabView()
            }*/
        }
    }
    
}

struct SignInWithAppleView: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
