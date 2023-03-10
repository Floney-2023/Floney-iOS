//
//  FindPasswordView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct FindPasswordView: View {
    @State var email = ""
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("비밀번호 찾기")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("비밀번호를 찾으려면\n가입한 이메일 주소를 입력하세요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            VStack(spacing: 20) {
                TextField("", text: $email)
                    .padding()
                    .keyboardType(.emailAddress)
                    .overlay(
                        Text("이메일을 입력하세요")
                            .padding()
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale6)
                            .opacity(email.isEmpty ? 1 : 0), alignment: .leading
                    )
                    .modifier(TextFieldModifier())
                Text("인증 메일 보내기")
                    .padding()
                    .modifier(NextButtonModifier())
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 52, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        .onTapGesture {
            // Hide the keyboard
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            // Set the TextField as the first responder
            DispatchQueue.main.async {
                UIApplication.shared.windows.first?.rootViewController?.view.endEditing(false)
            }
        }
    }
}

struct FindPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FindPasswordView()
    }
}
