//
//  SendAccountCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/08.
//

import SwiftUI
struct SendBookCodeView: View {
    let scaler = Scaler.shared

    @StateObject var viewModel = CreateBookViewModel()

    var body: some View {
        VStack(spacing:scaler.scaleHeight(20)) {
            HStack {
                VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                    Text("초대받은\n가계부가 있나요?")
                        .lineSpacing(6)
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                        .foregroundColor(.greyScale1)
                    Text("친구에게 받은 코드를 입력하거나\n코드가 없다면 가계부를 새로 만들 수 있어요.")
                        .lineSpacing(4)
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            CustomTextField(text: $viewModel.bookCode, placeholder: "코드를 입력하세요.", placeholderColor: .greyScale6)
                .frame(height: scaler.scaleHeight(46))
                .frame(width: scaler.scaleWidth(320))
            Spacer()
            
            VStack(spacing: scaler.scaleHeight(12)) {
                NavigationLink(destination: EnterBookView(), isActive: $viewModel.isNextToEnterBook){
                    Text("입력 완료하기")
                        .padding(scaler.scaleHeight(16))
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
                NavigationLink(destination: SetBookNameView(createBookType: .initial)){
                    Text("새 가계부 만들기")
                        .padding()
                        .foregroundColor(.primary1)
                        .modifier(NextButtonModifier(backgroundColor: .primary9))
                    
                }
            }
        }
        .padding(EdgeInsets(top:scaler.scaleHeight(78), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(40), trailing: scaler.scaleWidth(24)))
        .navigationBarBackButtonHidden(true)
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

struct SendBookCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SendBookCodeView()
    }
}
