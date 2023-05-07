//
//  ServiceAgreementView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/07.
//

import SwiftUI

struct ServiceAgreementView: View {
    var pageCount = 1
    var pageCountAll = 4
    @StateObject private var viewModel = ServiceAgreementViewModel()

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
                /*
                HStack(spacing: 14) {
                    Image(viewModel.isAllAgreed ? "check_primary" : "checkbox_primary" )
                    
                    Text("전체 동의")
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                }*/
                ServiceAgreementButton(isAgreed: $viewModel.isAllAgreed, checkboxType: "all", forwardButton: false,
                    title: "전체 동의")
                
                Divider()
                    .foregroundColor(.greyScale10)
                    .padding(0)
                
                /*
                HStack(spacing: 14) {
                    Image(viewModel.isTerm1Agreed ? "check_primary" : "checkbox_grey")
                    Text("이용 약관 동의 (필수)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
               */
                ServiceAgreementButton(isAgreed: $viewModel.isTerm1Agreed, title: "이용 약관 동의 (필수)")
                ServiceAgreementButton(isAgreed: $viewModel.isTerm2Agreed, title: "만 14세 이상 확인 (필수)")

                ServiceAgreementButton(isAgreed: $viewModel.isTerm3Agreed, title: "개인정보 수집 및 이용 동의 (필수)")
                ServiceAgreementButton(isAgreed: $viewModel.isOptionalTermAgreed, title: "마케팅 정보 수신 동의 (선택)")
/*
                HStack(spacing: 14) {
                    Image(viewModel.isTerm2Agreed ? "check_primary" : "checkbox_grey")
                    Text("만 14세 이상 확인 (필수)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                */
                /*
                HStack(spacing: 14) {
                    Image(viewModel.isTerm3Agreed ? "check_primary" : "checkbox_grey")
                    Text("개인정보 수집 및 이용 동의 (필수)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                 */
                /*
                HStack(spacing: 14) {
                    Image(viewModel.isOptionalTermAgreed ? "check_primary" : "checkbox_grey")
                    Text("마케팅 정보 수신 동의 (선택)")
                        .font(.pretendardFont(.regular, size: 14))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
*/
            }
            
            Spacer()

            NavigationLink(destination: EmailAuthView()){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .disabled(!(viewModel.isTerm1Agreed && viewModel.isTerm2Agreed && viewModel.isTerm3Agreed))
                    
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        
    }
}

struct ServiceAgreementButton: View {
    @Binding var isAgreed: Bool
    @State var checkboxType: String = "term"
    @State var forwardButton : Bool = true
    let title: String

    var body: some View {
        Button(action: {
            isAgreed.toggle()
        }) {
            HStack(spacing: 14) {
                if checkboxType == "term" {
                    Image(isAgreed ? "check_primary" : "checkbox_grey")
                } else if checkboxType == "all" {
                    Image(isAgreed ? "checkbox_primary" : "check_primary")
                }
                    
                Text(title)
                    .font(.pretendardFont(.regular, size: 14))
                    .foregroundColor(.greyScale2)
                Spacer()
                if forwardButton {
                    Image("forward_button")
                }
            }
        }
    }
}


struct ServiceAgreementView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceAgreementView()
    }
}
