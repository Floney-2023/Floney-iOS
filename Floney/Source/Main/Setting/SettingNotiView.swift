//
//  SettingNotiView.swift
//  Floney
//
//  Created by 남경민 on 2023/11/03.
//

import SwiftUI

struct SettingNotiView: View {
    @StateObject var viewModel = SettingViewModel()
    let scaler = Scaler.shared

    var body: some View {
        VStack(spacing:0) {
            HStack {
                Text("마케팅 정보 수신 알림")
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                    .foregroundColor(.greyScale2)
                Spacer()
                Toggle(isOn : $viewModel.marketingAgree) {
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.primary5))
            }
            .frame(height: scaler.scaleHeight(54))
        }
        .padding(.leading, scaler.scaleWidth(24))
        .padding(.trailing, scaler.scaleWidth(20))
        .customNavigationBar(
            leftView: { BackButtonBlack() },
            centerView: {
                Text("알림 설정")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                .foregroundColor(.greyScale1) }
        )
        .onAppear {
            viewModel.getMarketing()
        }
        .onChange(of : viewModel.marketingAgree) { newValue in
            viewModel.postMarketing()   
        }

    }
}

struct SettingNotiView_Previews: PreviewProvider {
    static var previews: some View {
        SettingNotiView()
    }
}
