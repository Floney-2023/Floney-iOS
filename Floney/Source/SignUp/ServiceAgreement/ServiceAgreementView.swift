//
//  ServiceAgreementView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/07.
//

import SwiftUI

struct ServiceAgreementView: View {
    var pageCount = 1
    var pageCountAll = 3
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                    
                    Text("약관 동의")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                }
                Spacer()
            }
            VStack(spacing: 20) {
                
                HStack(spacing: 14) {
                    Image("checkbox_primary")
                    Text("전체 동의")
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }
                
                Divider()
                    .foregroundColor(.greyScale10)
                    .padding(0)
                
                HStack(spacing: 14) {
                    Image("checkbox_grey")
                    Text("이용 약관 동의 (필수)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
               
                HStack(spacing: 14) {
                    Image("checkbox_grey")
                    Text("만 14세 이상 확인 (필수)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                
                HStack(spacing: 14) {
                    Image("checkbox_grey")
                    Text("개인정보 수집 및 이용 동의 (필수)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                
                HStack(spacing: 14) {
                    Image("checkbox_grey")
                    Text("마케팅 정보 수신 동의 (선택)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                
                
                
            }
            
            Spacer()
            
            NavigationLink(destination: SignUpView()){
                Text("다음으로")
                    .padding()
                    .modifier(NextButtonModifier())
            }
            
            

        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        
    }
}

struct ServiceAgreementView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceAgreementView()
    }
}
