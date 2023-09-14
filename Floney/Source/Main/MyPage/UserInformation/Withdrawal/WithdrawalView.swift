//
//  WithdrawalView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/26.
//

import SwiftUI

struct WithdrawalView: View {
    @State var placeholderText: String = "이유를 작성해주세요"
    @State var content: String = ""
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("회원탈퇴 전\n이유를 선택해주세요 😢")
                            .font(.pretendardFont(.bold, size: 24))
                            .foregroundColor(.greyScale1)
                        Text("잠깐! 탈퇴시 모든 구독이 자동해지되며,\n가계부 기록이 자동삭제 됩니다.")
                            .font(.pretendardFont(.medium, size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                VStack(spacing:40) {
                    HStack {
                        Text("플로니를 어떻게 사용하는지 모르겠어요")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("checkbox_grey")
                    }
                    HStack {
                        Text("구독료가 비싸요")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("checkbox_grey")
                    }
                    HStack {
                        Text("자주 사용하지 않게 돼요")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("checkbox_grey")
                    }
                    HStack {
                        Text("다시 가입할 거예요")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("checkbox_grey")
                    }
                    HStack {
                        Text("직접 입력하기")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Image("checkbox_grey")
                    }
                    
                }
                
                
                TextEditor(text: $content)
                    .font(.pretendardFont(.regular, size: 14))
                    .foregroundColor(.greyScale2)
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                    .lineSpacing(10)
                    .background(Color.background1)
                    .cornerRadius(12)
                //.padding(.horizontal,20)
                    .padding(.bottom, 40)
                
                /*
                 if self.content.isEmpty {
                 Text(self.placeholderText)
                 .font(.pretendardFont(.regular, size: 14))
                 .lineSpacing(10)
                 .foregroundColor(.greyScale6)
                 .padding(.top, 38)
                 .padding(.horizontal, 40)
                 }
                 */
     
                Spacer()
                //NavigationLink(destination: EmailAuthView()){
                    Text("탈퇴하기")
                        .padding()
                        .withNextButtonFormmating(.primary1)
               // }

            }
            .padding(EdgeInsets(top: 30, leading: 24, bottom: 0, trailing: 24))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton())
            
            
        }
    }
}

struct WithdrawalView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawalView()
    }
}
