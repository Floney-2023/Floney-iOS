//
//  EmailAuthView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/17.
//

import SwiftUI

struct EmailAuthView: View {
    @State var email = ""
    var pageCount = 2
    var pageCountAll = 4
    @StateObject var viewModel = SignUpViewModel()
    @State var isAllActive = false
    @State var emailEmpty = true // 이메일이 비어있는지 유무
   
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                        
                        Text("이메일 인증")
                            .font(.pretendardFont(.bold, size: 24))
                            .foregroundColor(.greyScale1)
 
                        Text("이메일 인증을 위해 사용 가능한\n이메일을 입력해주세요.")
                            .font(.pretendardFont(.medium, size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    
                    Spacer()
                    
                }
                TextField("", text: $viewModel.email)
                    .padding()
                    .keyboardType(.emailAddress)
                    .overlay(
                        Text("이메일을 입력하세요.")
                            .padding()
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale6)
                            .opacity(viewModel.email.isEmpty ? 1 : 0), alignment: .leading
                    )
                    .modifier(TextFieldModifier())
                    
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
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            .onAppear(perform : UIApplication.shared.hideKeyboard)
            
            CustomAlertView(message: viewModel.errorMessage, isPresented: $viewModel.showAlert)
        }
    }
}

struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAuthView()
    }
}
