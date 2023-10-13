//
//  SuccessSignoutView.swift
//  Floney
//
//  Created by 남경민 on 2023/10/04.
//

import SwiftUI

struct SuccessSignoutView: View {
     var body: some View {
         VStack(spacing: 30) {
             HStack {
                 VStack(alignment: .leading, spacing: 16) {
                     
                     Text("회원탈퇴가\n무사히 완료되었어요")
                         .font(.pretendardFont(.bold, size: 24))
                         .foregroundColor(.greyScale1)
                     Text("이용해 주셔서 감사합니다.\n언제든 다시 돌아오세요!")
                         .font(.pretendardFont(.medium, size: 13))
                         .foregroundColor(.greyScale6)
                 }
                 Spacer()
             }
             Spacer()
             Image("illust_signout")
             Spacer()
             Text("닫기")
                 .padding()
                 .withNextButtonFormmating(.primary1)
                 .onTapGesture {
                     
                 }
         }
         .navigationBarBackButtonHidden()
         .padding(EdgeInsets(top: 76, leading: 24, bottom: 0, trailing: 24))
     }
}

struct SuccessSignoutView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessSignoutView()
    }
}
