//
//  EnterBookCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/07.
//

import SwiftUI

struct EnterBookCodeView: View {
    let scaler = Scaler.shared
    @StateObject var viewModel = CreateBookViewModel()
    
    var body: some View {
        VStack(spacing: scaler.scaleHeight(20)) {
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                    Text("가계부 코드 입력")
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                        .foregroundColor(.greyScale1)
                    
                    Text("가계부에 입장하기 위해\n초대받은 가계부의 코드를 입력하세요.")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            .padding(.leading, scaler.scaleWidth(4))
            
            CustomTextField(text: $viewModel.bookCode, placeholder: "코드를 입력하세요.", placeholderColor: .greyScale6)
                .frame(height: scaler.scaleHeight(46))
  
            Spacer()
            
        
            NavigationLink(destination: EnterBookView(), isActive: $viewModel.isNextToEnterBook){
                Text("추가하기")
                    .padding()
                    .modifier(NextButtonModifier(backgroundColor: .primary1))
                    .onTapGesture {
                        if viewModel.isValidBookCode() {
                            LoadingManager.shared.update(showLoading: true, loadingType: .floneyLoading)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                                viewModel.joinBook()
                            }
                        }
                    }
            }
            
            
        }
        .padding(EdgeInsets(top:scaler.scaleHeight(60), leading: scaler.scaleWidth(20), bottom: scaler.scaleHeight(66), trailing: scaler.scaleWidth(20)))
        .customNavigationBar(
            leftView: { BackButton() }
            )
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        .edgesIgnoringSafeArea(.bottom)
        
        
    }
    
}

struct EnterBookCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBookCodeView()
    }
}
