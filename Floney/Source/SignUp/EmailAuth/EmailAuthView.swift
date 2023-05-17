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
    var body: some View {
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
            
            if #available(iOS 15.0, *) {
                NavigationLink(destination: AuthCodeView()){
                    Text("메일 보내기")
                        .padding()
                        .withNextButtonFormmating(.primary1)
                    /*
                        .onTapGesture {
                            viewModel.authEmail()
                        }
                     */
                }
            } else {
                // Fallback on earlier versions
            }

        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct EmailAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EmailAuthView()
    }
}
