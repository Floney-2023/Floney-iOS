//
//  EnterBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/07.
//

import SwiftUI

struct EnterBookView: View {
    let scaler = Scaler.shared
    var body: some View {
        ZStack {
            VStack() {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        
                        Text("가계부에\n초대되었어요!")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                        Text("간편하고 쉬운 가계부, 플로니와 함께 해요")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                        
                    }
                    
                    Spacer()
                }
                Spacer()
                Image("book_illust")
                    .resizable()
                    .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
                    
                Spacer()
                
                Text("작성하러 가기")
                    .padding(scaler.scaleHeight(16))
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        BookExistenceViewModel.shared.getBookExistence()
                    }

            }
            .padding(EdgeInsets(top:scaler.scaleHeight(78), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(66), trailing: scaler.scaleWidth(24)))
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.bottom)

        }
    }
}

struct EnterBookView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBookView()
    }
}
