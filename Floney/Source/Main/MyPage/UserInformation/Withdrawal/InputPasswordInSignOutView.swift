//
//  InputPasswordInSignOutView.swift
//  Floney
//
//  Created by 남경민 on 11/24/23.
//

import SwiftUI

struct InputPasswordInSignOutView: View {
    let scaler = Scaler.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = MyPageViewModel()
    @State var signoutAlert = false
    @State var title = "탈퇴 전에 꼭 확인해 주세요"
    @State var message = "-가계부 방장일 경우 팀원에게\n방장이 자동으로 위임되며 가계부를 나가게 됩니다.\n\n-가계부 팀원일 경우 즉시 가계부를 나가게 됩니다.\n\n-모든 사용자는 회원탈퇴 시 모든 가계부 및\n데이터, 개인정보가 즉시 파기됩니다.\n\n그래도 탈퇴하시겠습니까?"
    @State var password = ""

    var body: some View {
        ZStack{
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(5)) {
                        Text("마지막으로 비밀번호를")
                        Text("입력해 주세요.")
                    }
                    .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                    .foregroundColor(.greyScale1)
                    Spacer()
                }
                .padding(.horizontal,scaler.scaleWidth(4))
                .padding(.bottom, scaler.scaleHeight(56))
                CustomTextField(text: $password,placeholder: "비밀번호",isSecure: true, placeholderColor: .greyScale6)
                    .frame(width: scaler.scaleWidth(320), height:scaler.scaleHeight(46))
                
                Spacer()
                Text("탈퇴하기")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        // if viewModel.isValidSignout() {
                        signoutAlert = true
                        
                        // }
                    }
                    .padding(.bottom, scaler.scaleHeight(38))
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(30), leading:scaler.scaleWidth(20), bottom: 0, trailing:scaler.scaleWidth(20)))
            .customNavigationBar(
                leftView: { BackButton() }
            )
            .edgesIgnoringSafeArea(.bottom)
            
            if signoutAlert {
                SignoutAlertView(isPresented: $signoutAlert, title: $title, message: $message, onOKAction: {
                    viewModel.signout()
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
            NavigationLink(destination: SuccessSignoutView(),isActive: $viewModel.isNextToSuccessSignout){
                EmptyView()
            }
        }
    }
}

#Preview {
    InputPasswordInSignOutView()
}

struct SignoutAlertView: View {
    let scaler = Scaler.shared
    @Binding var isPresented: Bool
    @Binding var title : String
    @Binding var message : String
    @State var leftColor : Color = .greyScale6
    @State var rightColor : Color = .white
    @State var leftButtonText = "탈퇴하기"
    @State var rightButtonText = "취소하기"
    var onOKAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing:0) {
                Image("illust_warning")
                VStack(spacing:scaler.scaleHeight(14)) {
                    Text("\(title)")
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(16)))
                    
                    Text("\(message)")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(13)))
                        .multilineTextAlignment(.center)
                }.padding(.vertical, scaler.scaleHeight(20))
                    .foregroundColor(.greyScale1)
       
                HStack(alignment: .center,spacing: scaler.scaleWidth(12)) {
                    Button("\(leftButtonText)") {
                        isPresented = false
                        onOKAction()
                    }
                    .padding(.vertical,scaler.scaleHeight(16))
                    .frame(width: geometry.size.width * 0.34)
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                    .foregroundColor(leftColor)
                    .background(Color.background2)
                    .cornerRadius(10)

                    Button("\(rightButtonText)") {
                        isPresented = false
                    }
                    .padding(.vertical,scaler.scaleHeight(16))
                    .frame(width: geometry.size.width * 0.34)
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                    .foregroundColor(rightColor)
                    .background(Color.primary1)
                    .cornerRadius(10)
                }
          
            }
            .frame(width: geometry.size.width * 0.8)
            .frame(height: geometry.size.height * 0.5)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(Color.black.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }

    }
}
