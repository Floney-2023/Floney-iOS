//
//  SuccessSignoutView.swift
//  Floney
//
//  Created by 남경민 on 2023/10/04.
//

import SwiftUI

struct SuccessSignoutView: View {
    let scaler = Scaler.shared
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing:scaler.scaleHeight(40)) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(6)) {
                            Text("회원탈퇴가")
                            Text("무사히 완료되었어요")
                        }
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                        .foregroundColor(.greyScale1)
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(4)) {
                            Text("이용해 주셔서 감사합니다.")
                            Text("언제든 다시 돌아오세요!")
                        }
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                        .foregroundColor(.greyScale6)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal,scaler.scaleWidth(24))
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
                    .background(
                        Image("illust_signout")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
                        
                    )
                
                Spacer()
                
                Text("닫기")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        AuthenticationService.shared.signoutStatus = false
                    }
            }
            .padding(EdgeInsets(top: scaler.scaleHeight(76), leading:scaler.scaleWidth(20), bottom: scaler.scaleHeight(38), trailing: scaler.scaleWidth(20)))
            .edgesIgnoringSafeArea(.bottom)
        }
     }
}

struct SuccessSignoutView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessSignoutView()
    }
}
