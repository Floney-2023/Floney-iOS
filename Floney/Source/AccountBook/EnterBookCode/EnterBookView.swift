//
//  EnterBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/07.
//

import SwiftUI

struct EnterBookView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("가계부에 초대되었어요!")
                            .font(.pretendardFont(.bold, size: 24))
                            .foregroundColor(.greyScale1)
                        Text("간편하고 쉬운 가계부, 플로니와 함께 해요")
                            .font(.pretendardFont(.medium, size: 13))
                            .foregroundColor(.greyScale6)
                        
                    }
                    
                    Spacer()
                }
                Image("book_illust")
                Spacer()
                
                
                Text("작성하러 가기")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        BookExistenceViewModel.shared.getBookExistence()
                    }

            }
            .padding(EdgeInsets(top: 78, leading: 24, bottom: 40, trailing: 24))
            .navigationBarBackButtonHidden(true)

        }
    }
}

struct EnterBookView_Previews: PreviewProvider {
    static var previews: some View {
        EnterBookView()
    }
}
