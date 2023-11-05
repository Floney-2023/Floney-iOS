//
//  SettingLanguage.swift
//  Floney
//
//  Created by 남경민 on 2023/11/03.
//

import SwiftUI

struct SettingLanguageView: View {
    let scaler = Scaler.shared
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text("한국어")
                    .font(.pretendardFont(.medium,size:scaler.scaleWidth(14)))
                    .foregroundColor(.primary2)
                Spacer()
                Image("icon_check_circle_activated")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                    .padding(.trailing, scaler.scaleWidth(14))
                
            }
            .padding(.leading, scaler.scaleWidth(20))
            .frame(height:scaler.scaleHeight(54))
            .background(Color.primary10)
            .cornerRadius(12)
            .padding(.top, scaler.scaleHeight(6))
        }
        .padding(.horizontal, scaler.scaleWidth(20))

        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("언어 설정")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                .foregroundColor(.greyScale1) }
        )
    }
}

struct SettingLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLanguageView()
    }
}
