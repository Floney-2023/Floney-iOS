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
    @StateObject var viewModel = SignInViewModel()
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
                        
                        
                        TextField("", text: $viewModel.password)
                            .padding()
                            .overlay(
                                Text("비밀번호")
                                    .padding()
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale7)
                                    .opacity(viewModel.password.isEmpty ? 1 : 0), alignment: .leading
                            )
                            .modifier(TextFieldModifier())
                        
                        Text("로그인 하기")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                            .onTapGesture {
                                //let signInRequest = SignInRequest(email: email, password: password)
                                viewModel.postSignIn()
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
                            Image("btn_google")
                            Image("btn_apple")
                        }
                    }
                    Spacer()
                }
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
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
