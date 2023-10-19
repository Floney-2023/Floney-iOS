//
//  WelcomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct WelcomeView: View {
    let scaler = Scaler.shared
    @State var nickname = Keychain.getKeychainValue(forKey: .userNickname) ?? "플로니"
    var body: some View {
        NavigationView {
            VStack() {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        Text("환영합니다\n\(nickname)님!")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(24) ))
                            .foregroundColor(.greyScale1)
                        Text("플로니와 함께 똑똑하고 편리한 가계부를\n작성해보세요.")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                Spacer()
                Image("icon_welcome")
                    .resizable()
                    .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
                Spacer()
                NavigationLink(destination: SendBookCodeView()){
                    Text("플로니 시작하기")
                        .padding(scaler.scaleHeight(16))
                        .withNextButtonFormmating(.primary1)
                }
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(78), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(38), trailing: scaler.scaleWidth(24)))
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
