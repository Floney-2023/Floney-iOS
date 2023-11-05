//
//  InactivieAlertView.swift
//  Floney
//
//  Created by 남경민 on 2023/11/06.
//

import SwiftUI

struct InactiveAlertView: View {
    let scaler = Scaler.shared
    let title: String = "구독 후 다시 이용해 보세요"
    let message: String = "현재 가계부에 구독 혜택이 적용되어 있습니다.\n지금은 마이페이지, 가계부 설정만 사용할 수 있어요."
    @Binding var isPresented: Bool
    var body: some View {
        if (isPresented) {
            ZStack {
                Color.black.opacity(0.7)
                VStack{
                    Spacer()
                    VStack(spacing:scaler.scaleHeight(12)) {
                        HStack {
                            Text("\(title)")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                .foregroundColor(.white)
                            Spacer()
                            Image("icon_close_white")
                                .onTapGesture {
                                    isPresented = false
                                }
                                
                        }
                        .padding(.horizontal,scaler.scaleWidth(20))
                        HStack {
                            Text("\(message)")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(13)))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal,scaler.scaleWidth(20))
                    }
                    
                    .frame(width: scaler.scaleWidth(344), height: scaler.scaleHeight(104))
                    .background(Color.primary5)
                    .cornerRadius(12)
                    .animation(.easeInOut, value: isPresented)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, scaler.scaleHeight(92))
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct InactiveAlertView_Previews: PreviewProvider {
    static var previews: some View {
        InactiveAlertView(isPresented: .constant(true))
    }
}
