//
//  ModifyingBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI

struct ModifyingBookView: View {
    @ObservedObject var viewModel : SettingBookViewModel
    //@State var nickname = ""
    @State var toggleOnOff = true
    var body: some View {
        VStack(spacing:36) {
            VStack(spacing:12) {
                HStack{
                    Text("가계부 이름")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }
                HStack(spacing: 8) {
                    TextField("", text: $viewModel.changedName)
                        .padding()
                        //.keyboardType(.emailAddress)
                        .overlay(
                            Text("이름을 입력하세요.")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale7)
                                .opacity(viewModel.changedName.isEmpty ? 1 : 0), alignment: .leading
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
                NavigationLink(destination: SetBookProfileImageView(viewModel: viewModel)){
                    HStack {
                        Text("프로필 이미지 변경")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("forward_button")
                    }
                }
                
                HStack {
                    Text("내역 프로필 보기")
                        .font(.pretendardFont(.medium, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Toggle(isOn: $viewModel.profileStatus) {
                        
                    }.padding(.trailing, 6)
                        
                }
                .onReceive(viewModel.$profileStatus) { profileStatus in
                    print("see profile status : \(viewModel.profileStatus)")
                        viewModel.changeProfileStatus()
                }
                
            }
            
            NavigationLink(destination: WithdrawalView()){
                HStack {
                    VStack {
                        Text("가계부 삭제")
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
                Text("가계부 편집")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
            }
        }
        
    }
}

struct ModifyingBookView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyingBookView(viewModel: SettingBookViewModel())
    }
}
