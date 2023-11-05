//
//  SettingView.swift
//  Floney
//
//  Created by 남경민 on 2023/11/03.
//

import SwiftUI

struct SettingView: View {
    let scaler = Scaler.shared

    var body: some View {
        VStack(spacing:0) {
            NavigationLink(destination : SettingNotiView()) {
                HStack {
                    Text("알림 설정")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                .frame(height: scaler.scaleHeight(54))
            }
            NavigationLink(destination : SettingLanguageView()) {
                HStack {
                    Text("언어 설정")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("forward_button")
                }
                .frame(height: scaler.scaleHeight(54))
            }
            HStack {
                Text("오픈소스 라이브러리")
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                    .foregroundColor(.greyScale2)
                Spacer()
                Image("forward_button")
            }
            .frame(height: scaler.scaleHeight(54))
            HStack {
                Text("Version 1.1")
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                    .foregroundColor(.greyScale2)
                Spacer()

            }
            .frame(height: scaler.scaleHeight(54))


        }
        .padding(.leading, scaler.scaleWidth(24))
        .padding(.trailing, scaler.scaleWidth(20))
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("설정")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                .foregroundColor(.greyScale1) }
        )

    }

}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
