//
//  EmailAuthView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/17.
//

import SwiftUI

struct EmailAuthView: View {
    let scaler = Scaler.shared
    @State var email = ""
    var pageCount = 2
    var pageCountAll = 4
    @ObservedObject var viewModel : SignUpViewModel
    @ObservedObject var loadingManager = LoadingManager.shared
    @State var isAllActive = false
    @State var emailEmpty = true // 이메일이 비어있는지 유무
   
    var body: some View {
        ZStack {
            VStack(spacing: scaler.scaleHeight(20)) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        
                        Text("이메일 인증")
                            .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                        
                        Text("이메일 인증을 위해 사용 가능한\n이메일을 입력해주세요.")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, scaler.scaleWidth(4))
                
                CustomTextField(text: $viewModel.email, placeholder: "이메일을 입력하세요",keyboardType: .emailAddress, placeholderColor: .greyScale6)
                    .frame(height: scaler.scaleHeight(46))
               
                Spacer()
                
                //MARK: iOS 15.0 이상인 경우
                if #available(iOS 15.0, *) {
                    NavigationLink(destination: AuthCodeView(viewModel: viewModel), isActive: $viewModel.isNextToAuthCode){
                        Text("메일 보내기")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                            .onTapGesture {
                                viewModel.checkEmail()
                            }
                        
                    }
                    //MARK: iOS 15.0 미만인 경우
                } else {
                    // Fallback on earlier versions
                }
                
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(32), leading: scaler.scaleWidth(20), bottom: scaler.scaleHeight(38), trailing: scaler.scaleWidth(20)))
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            .customNavigationBar(
                leftView: { BackButton() }
                )
            
            CustomAlertView(message: viewModel.errorMessage, type: $viewModel.buttonType, isPresented: $viewModel.showAlert)
            // Loading view overlay
            if loadingManager.showLoading {
                if loadingManager.loadingType == .floneyLoading {
                    LoadingView()
                }
                else if loadingManager.loadingType == .progressLoading{
                    ProgressLoadingView()
                } else {
                    DimmedLoadingView()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAuthView(viewModel: SignUpViewModel())
    }
}
