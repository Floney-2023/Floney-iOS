//
//  EnterBookCodeView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/07.
//

import SwiftUI

struct EnterBookCodeView: View {
    @State var accountCode = ""
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("가계부 코드 입력")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("가계부에 입장하기 위해\n초대받은 가계부의 코드를 입력하세요.")
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
                NavigationLink(destination: EnterBookView()){
                    Text("추가하기")
                        .padding()
                        .modifier(NextButtonModifier(backgroundColor: .primary1))
                }
               
            }

        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        
        
    }
    
}

struct EnterBookCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBookCodeView()
    }
}