//
//  ModifyingBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI

struct ModifyingBookView: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : SettingBookViewModel
    @State var toggleOnOff = true
    @State var deleteAlert = false
    @State var deleteTitle = "가계부 삭제"
    @State var deleteMessage = "가계부를 삭제할 시 모든 내역이 삭제됩니다. 삭제하시겠습니까?"
    var body: some View {
        VStack(spacing:scaler.scaleHeight(16)) {
            VStack(spacing:scaler.scaleHeight(12)) {
                HStack{
                    Text("가계부 이름")
                        .font(.pretendardFont(.medium, size:scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }
                .padding(.leading, scaler.scaleWidth(4))
                HStack(spacing: scaler.scaleWidth(8)) {
                    CustomTextField(width:226, text: $viewModel.changedName, placeholder: "이름을 입력하세요.", placeholderColor: .greyScale7)
                        .frame(height: scaler.scaleHeight(46))
                    
                    Button("변경하기"){
                        if viewModel.isValidChangedName() {
                            viewModel.changeNickname()
                        }
                        
                    }
                    .padding()
                    .font(.pretendardFont(.bold, size: scaler.scaleWidth(12)))
                    .foregroundColor(.white)
                    .frame(width: scaler.scaleWidth(86))
                    .frame(height: scaler.scaleHeight(46))
                    .background(Color.primary1)
                    .cornerRadius(12)
                }
            }
            
            VStack(spacing:scaler.scaleHeight(24)) {
                NavigationLink(destination: SetBookProfileImageView()){
                    HStack {
                        Text("프로필 이미지 변경")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("forward_button")
                    }
                    .padding(.leading, scaler.scaleWidth(4))
                    .frame(height: scaler.scaleHeight(46))
                }

                HStack {
                    Text("내역 프로필 보기")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Toggle(isOn: $viewModel.profileStatus) {
                        
                    }
                    .padding(.trailing, scaler.scaleWidth(6))
                        
                }
                .padding(.leading, scaler.scaleWidth(4))
                .onReceive(viewModel.$profileStatus) { profileStatus in
                    print("see profile status : \(viewModel.profileStatus)")
                }
            }
            
            if viewModel.role == "방장" {
                HStack {
                    VStack(spacing:0) {
                        Text("가계부 삭제")
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale6)
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: scaler.scaleWidth(55), height: scaler.scaleWidth(0.5))
                          .background(Color.greyScale6)
                        
                    }
                    Spacer()
                }
                .padding(.top, scaler.scaleHeight(24))
                .padding(.leading, scaler.scaleWidth(4))
                .onTapGesture {
                    self.deleteAlert = true
                }
                
            }
            Spacer()
            
        }
        .padding(EdgeInsets(top: scaler.scaleHeight(32), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("가계부 편집")
                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)
            }
        )
        .overlay(
            ZStack {
                if deleteAlert {
                    AlertView(isPresented: $deleteAlert, title: $deleteTitle, message: $deleteMessage, okColor: .alertRed, onOKAction: {
                        DispatchQueue.main.async {
                            viewModel.deleteBook()
                        }
                        
                    })
                }
                
            }
        )
        .onAppear(perform : UIApplication.shared.hideKeyboard)
    }
}

struct ModifyingBookView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyingBookView(viewModel: SettingBookViewModel())
    }
}
