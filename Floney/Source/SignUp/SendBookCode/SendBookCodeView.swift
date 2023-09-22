//
//  SendAccountCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/08.
//

import SwiftUI
struct SendBookCodeView: View {
    @State var accountCode = ""
    @StateObject var viewModel = BookCodeViewModel()
    @State var isActive = false
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("초대받은\n가계부가 있나요?")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("친구에게 받은 코드를 입력하거나\n코드가 없다면 가계부를 새로 만들 수 있어요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            CustomTextField(text: $viewModel.code, placeholder: "코드를 입력하세요.", placeholderColor: .greyScale6)
                .frame(height: UIScreen.main.bounds.height * 0.06)
           
            Spacer()
            
            VStack(spacing: 12) {
                NavigationLink(destination: EnterBookView(), isActive: $viewModel.isNext){
                    Text("입력 완료하기")
                        .padding()
                        .modifier(NextButtonModifier(backgroundColor: .primary1))
                        .onTapGesture {
                            if viewModel.isVaildBookCode() {
                                viewModel.postBookCode()
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
        .padding(EdgeInsets(top: 78, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .onAppear(perform : UIApplication.shared.hideKeyboard)
        
    }
}

struct SendBookCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SendBookCodeView()
    }
}
