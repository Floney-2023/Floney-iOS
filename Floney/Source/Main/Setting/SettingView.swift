//
//  SettingView.swift
//  Floney
//
//  Created by 남경민 on 2023/11/03.
//

import SwiftUI

struct SettingView: View {
    let scaler = Scaler.shared
    let version = AppVersionCheck.appVersion ?? "1.0.0"
    var body: some View {
        VStack(spacing:0) {
            NavigationLink(destination : SettingNotiView()) {
                HStack {
                    Text("알림 설정")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("icon_setting_book_forward")
                }
                .frame(height: scaler.scaleHeight(54))
            }
            NavigationLink(destination : SettingLanguageView()) {
                HStack {
                    Text("언어 설정")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Image("icon_setting_book_forward")
                }
                .frame(height: scaler.scaleHeight(54))
            }
            HStack {
                Text("Version \(version)")
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
