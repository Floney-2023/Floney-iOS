//
//  UserInformationView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/21.
//

import SwiftUI

struct UserInformationView: View {
    @StateObject var alertManager = AlertManager.shared
    @StateObject var viewModel = MyPageViewModel()

    @State  var provider : String = Keychain.getKeychainValue(forKey: .provider) ?? ""
    @State var showingLogoutAlert = false
    @State var title = "로그아웃"
    @State var message = "로그아웃 하시겠습니끼?"
    var body: some View {
        VStack(spacing:36) {
            VStack(spacing:12) {
                HStack{
                    Text("닉네임")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }
                HStack(spacing: 8) {
                    TextField("", text: $viewModel.changedNickname)
                        .padding()
                        .keyboardType(.emailAddress)
                        .overlay(
                            Text("닉네임을 입력하세요.")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale7)
                                .opacity(viewModel.changedNickname.isEmpty ? 1 : 0), alignment: .leading
                        )
                        .modifier(TextFieldModifier())
                    Button("변경하기"){
                        viewModel.changeNickname()
                    }
                    .padding()
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: 86)
                    .background(Color.primary1)
                    .cornerRadius(12)
                }
            }
            
            VStack(spacing:30) {
                NavigationLink(destination: SetProfileImageView()){
                    HStack {
                        Text("프로필 이미지 변경")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("forward_button")
                    }
                    
                }
                if self.provider == "EMAIL" {
                    NavigationLink(destination: ChangePasswordView()){
                        HStack {
                            Text("비밀번호 변경")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                    }
                }
                HStack {
                    Text("로그아웃")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale2)
                        .onTapGesture {
                            self.showingLogoutAlert = true
                        }
                    Spacer()
                }
                
            }
            
            NavigationLink(destination: WithdrawalView()){
                HStack {
                    VStack {
                        Text("회원탈퇴")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale6)
                        Divider()
                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: 50,height: 1.0)
                            .foregroundColor(.greyScale6)
                        
                    }
                    Spacer()
                }
            }
            Spacer()
            
        }
        .padding(EdgeInsets(top: 35, leading: 20, bottom: 0, trailing: 20))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonBlack())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("회원 정보")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
            }
        }
        .overlay(
            ZStack {
                if showingLogoutAlert {
                    AlertView(isPresented: $showingLogoutAlert, title: $title, message: $message, onOKAction: {viewModel.logout()})
                }
               
            }
        )

    }
}


struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView()
    }
}
