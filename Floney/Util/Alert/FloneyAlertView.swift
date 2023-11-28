//
//  FloneyAlertView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/09.
//

import SwiftUI

struct FloneyAlertView: View {
    let scaler = Scaler.shared
    @Binding var isPresented: Bool
    @Binding var title : String
    @Binding var message : String
    @State var leftColor : Color = .greyScale6
    @State var rightColor : Color = .white
    @State var leftButtonText = "초기화하기"
    @State var rightButtonText = "취소하기"
    var onOKAction: () -> Void
    //var onCancelAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing:0) {
                Image("illust_warning")
                VStack(spacing:scaler.scaleHeight(14)) {
                    Text("\(title)")
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(16)))
                    
                    Text("\(message)")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(13)))
                        .multilineTextAlignment(.center)
                }.padding(.vertical, scaler.scaleHeight(20))
                    .foregroundColor(.greyScale1)
       
                HStack(alignment: .center,spacing: scaler.scaleWidth(12)) {
                    Button("\(leftButtonText)") {
                        isPresented = false
                        onOKAction()
                    }
                    .padding(.vertical,scaler.scaleHeight(16))
                    .frame(width: geometry.size.width * 0.34)
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                    .foregroundColor(leftColor)
                    .background(Color.background2)
                    .cornerRadius(10)

                    Button("\(rightButtonText)") {
                        isPresented = false
                    }
                    .padding(.vertical,scaler.scaleHeight(16))
                    .frame(width: geometry.size.width * 0.34)
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                    .foregroundColor(rightColor)
                    .background(Color.primary1)
                    .cornerRadius(10)
                }
          
            }
            .frame(width: geometry.size.width * 0.8)
            .frame(height: geometry.size.height * 0.35)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(Color.black.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }

    }
}
struct BlackFloneyAlertView: View {
    let scaler = Scaler.shared
    @Binding var isPresented: Bool
    @Binding var title : String
    @Binding var message : String

    @State var centerButtonText = "확인"

    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing:0) {
                Image("illust_black_alert")
                VStack(spacing:scaler.scaleHeight(14)) {
                    Text("\(title)")
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(16)))
                    
                    Text("\(message)")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(13)))
                        .multilineTextAlignment(.center)
                }.padding(.vertical, scaler.scaleHeight(24))
                    .foregroundColor(.greyScale1)
       
                HStack(alignment: .center,spacing: scaler.scaleWidth(12)) {
                    Button("\(centerButtonText)") {
                        isPresented = false
                    }
                    .padding(.vertical,scaler.scaleHeight(16))
                    .frame(width: scaler.scaleWidth(124), height:scaler.scaleHeight(44))
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                    .foregroundColor(.white)
                    .background(Color.primary1)
                    .cornerRadius(10)
                }
          
            }
            .frame(width: geometry.size.width * 0.8)
            .frame(height: geometry.size.height * 0.38)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(Color.black.opacity(0.2))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }

    }
}

struct FloneyAlertView_Previews: PreviewProvider {
    static var previews: some View {
        BlackFloneyAlertView(isPresented: .constant(true), title: .constant("접근 권한이 없어요"), message: .constant("해당 가계부의 멤버가 아닙니다.\n소속된 가계부를 다시 확인해 주세요."))
    }
}
