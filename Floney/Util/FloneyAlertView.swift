//
//  FloneyAlertView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/09.
//

import SwiftUI

struct FloneyAlertView: View {
    @Binding var isPresented: Bool
    @Binding var title : String
    @Binding var message : String
    @State var leftColor : Color = .greyScale6
    @State var rightColor : Color = .white
    @State var leftButtonText = "초기화하기"
    @State var rightButtonText = "유지하기"
    var onOKAction: () -> Void
    //var onCancelAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing:0) {
                Image("illust_warning")
                VStack(spacing:14) {
                    Text("\(title)")
                        .font(.pretendardFont(.bold, size: 16))
                    
                    Text("\(message)")
                        .font(.pretendardFont(.regular, size: 13))
                        .multilineTextAlignment(.center)
                }.padding(.vertical, 20)
                    .foregroundColor(.greyScale1)
       
                HStack(alignment: .center,spacing: 12) {
                    Button("\(leftButtonText)") {
                        isPresented = false
                        onOKAction()
                    }
                    .padding(.vertical,16)
                    .frame(width: geometry.size.width * 0.34)
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(leftColor)
                    .background(Color.background2)
                    .cornerRadius(10)

                    Button("\(rightButtonText)") {
                        isPresented = false
                    }
                    .padding(.vertical,16)
                    .frame(width: geometry.size.width * 0.34)
                    .font(.pretendardFont(.semiBold, size: 12))
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

struct FloneyAlertView_Previews: PreviewProvider {
    static var previews: some View {
        FloneyAlertView(isPresented: .constant(true), title: .constant("모든 내역이 사라집니다."), message: .constant("화폐 단위를 USD(으)로 변경하시겠습니까?\n변경 시 기록된 전체 내역이 초기화됩니다."), onOKAction: {})
    }
}
