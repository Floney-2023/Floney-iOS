//
//  AlertView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/28.
//

import SwiftUI

struct AlertView: View {
    @Binding var isPresented: Bool
    @Binding var title : String
    @Binding var message : String
    @State var okColor : Color = .alertBlue
    var onOKAction: () -> Void
    //var onCancelAction: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing:0) {
                VStack(spacing:5) {
                    Text("\(title)")
                        .font(.pretendardFont(.semiBold, size: 17))
                    
                    
                    Text("\(message)")
                        .font(.pretendardFont(.regular, size: 13))
                        .multilineTextAlignment(.center)
                }.padding(.vertical, 20)
                
                Divider()
                    .foregroundColor(.alertGrey2)
                
                HStack(alignment: .center) {
                    Button("네") {
                        isPresented = false
                        onOKAction()
                    }
                    .frame(width: geometry.size.width * 0.35)
                    .font(.pretendardFont(.regular, size: 17))
                    .foregroundColor(okColor)
                 
                    Divider()
                        .foregroundColor(.alertGrey2)
                    Button("아니요") {
                        isPresented = false
                    }
                    .frame(width: geometry.size.width * 0.35)
                    .font(.pretendardFont(.regular, size: 17))
                    .foregroundColor(.alertBlue)
                }.frame(height: 44)
          
            }
            .frame(width: geometry.size.width * 0.75)
            .background(Color.alertGrey1.opacity(0.8))
            .cornerRadius(14)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(Color.black.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }

    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(isPresented: .constant(true), title: .constant("가계부 내역 초기화"), message: .constant("가계부 내역 초기화 시 모든 내역이 삭제됩니다. 초기화 하시겠습니까?"), onOKAction: {})
    }
}
