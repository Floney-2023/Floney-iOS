//
//  WelcomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct WelcomeView: View {
    @State var nickname = Keychain.getKeychainValue(forKey: .userNickname) ?? "플로니"
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("환영합니다\n\(nickname)님!")
                            .font(.pretendardFont(.bold, size: 24))
                            .foregroundColor(.greyScale1)
                        Text("플로니와 함께 똑똑하고 편리한 가계부를\n작성해보세요.")
                            .font(.pretendardFont(.medium, size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                Spacer()
                Image("icon_welcome")
                Spacer()
                NavigationLink(destination: SendBookCodeView()){
                    Text("플로니 시작하기")
                        .padding()
                        .withNextButtonFormmating(.primary1)
                }
            }
            .padding(EdgeInsets(top: 78, leading: 24, bottom: 0, trailing: 24))
            .navigationBarBackButtonHidden(true) 
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
