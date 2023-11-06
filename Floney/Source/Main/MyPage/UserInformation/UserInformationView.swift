//
//  UserInformationView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/21.
//

import SwiftUI

struct UserInformationView: View {
    let scaler = Scaler.shared
    @StateObject var alertManager = AlertManager.shared
    @StateObject var viewModel = MyPageViewModel()
    @State  var provider : String = Keychain.getKeychainValue(forKey: .provider) ?? ""
    @State var showingLogoutAlert = false
    @State var title = "로그아웃"
    @State var message = "로그아웃 하시겠습니끼?"
    var body: some View {
        VStack(spacing:scaler.scaleHeight(32)) {
            VStack(spacing:scaler.scaleHeight(12)) {
                HStack{
                    Text("닉네임")
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }
                .padding(.leading, scaler.scaleWidth(4))
                HStack(spacing: scaler.scaleHeight(8)) {
                    CustomTextField(width:226,text: $viewModel.changedNickname, placeholder: "닉네임을 입력하세요",placeholderColor: .greyScale7)
                        .frame(height: scaler.scaleHeight(46))
                        .frame(width: scaler.scaleWidth(226))
                   
                    Button("변경하기"){
                        if viewModel.isValidChangedName() {
                            viewModel.changeNickname()
                        }
                    }
                    .padding()
                    .font(.pretendardFont(.bold, size: scaler.scaleWidth(12)))
                    .frame(height: scaler.scaleHeight(46))
                    .foregroundColor(.white)
                    .frame(maxWidth:scaler.scaleWidth(86))
                    .background(Color.primary1)
                    .cornerRadius(12)
                }
            }
            
            VStack(spacing:scaler.scaleHeight(32)) {
                NavigationLink(destination: SetProfileImageView()){
                    HStack {
                        Text("프로필 이미지 변경")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("forward_button")
                    }
                    .padding(.leading, scaler.scaleWidth(4))
                    
                }
                if self.provider == "EMAIL" {
                    NavigationLink(destination: ChangePasswordView()){
                        HStack {
                            Text("비밀번호 변경")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                        .padding(.leading, scaler.scaleWidth(4))
                    }
                }
                HStack {
                    Text("로그아웃")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                        .onTapGesture {
                            self.showingLogoutAlert = true
                        }
                    Spacer()
                }
                .padding(.leading, scaler.scaleWidth(4))
                
            }
            NavigationLink(destination: WithdrawalView()){
                HStack {
                    VStack(spacing:0) {
                        Text("회원탈퇴")
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale6)
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: scaler.scaleWidth(42), height: scaler.scaleWidth(0.5))
                          .background(Color.greyScale6)
                    }
                    Spacer()
                }
                .padding(.leading, scaler.scaleWidth(4))
                .padding(.top, scaler.scaleHeight(2))
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top:scaler.scaleHeight(34), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: { Text("회원 정보")
                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                .foregroundColor(.greyScale1)}
            )
        .overlay(
            ZStack {
                if showingLogoutAlert {
                    AlertView(isPresented: $showingLogoutAlert, title: $title, message: $message, onOKAction: {
                        DispatchQueue.main.async {
                            viewModel.logout()
                        }
                    })
                }
            }
        )
        .onAppear(perform : UIApplication.shared.hideKeyboard)

    }
}


struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}
