//
//  SendAccountCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/08.
//

import SwiftUI
struct SendAccountCodeView: View {
    @State var accountCode = ""
    
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
            TextField("", text: $accountCode)
                .padding()
                .overlay(
                    Text("코드를 입력하세요.")
                        .padding()
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale6)
                        .opacity(accountCode.isEmpty ? 1 : 0), alignment: .leading
                )
                .modifier(TextFieldModifier())
            
            Spacer()
            
            VStack(spacing: 12) {
                NavigationLink(destination: WelcomeView()){
                    Text("입력 완료하기")
                        .padding()
                        .modifier(NextButtonModifier(backgroundColor: .primary1))
                }
                NavigationLink(destination: WelcomeView()){
                    Text("가계부 생성하기")
                        .padding()
                        .modifier(NextButtonModifier(backgroundColor: .greyScale2))
                        
                }
            }

        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        
        
    }
}

struct SendAccountCodeView_Previews: PreviewProvider {
    static var previews: some View {
        SendAccountCodeView()
    }
}