//
//  InviteBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/04.
//

import SwiftUI

struct InviteBookView: View {
    @State var bookCode = "18758F7A"
    @State var showAlert = false
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading,spacing: 10) {
                    Text("초대받은 가계부에")
                    Text("입장하기")
                }
                .font(.pretendardFont(.bold, size: 24))
                .foregroundColor(.greyScale1)
                Spacer()
            }
            .padding(.top, 78)
            .padding(.leading, 24)
            .padding(.bottom,48)
            
            Image("book_profile_110")
            Text("team")
                .font(.pretendardFont(.bold, size: 18))
                .foregroundColor(.greyScale2)
                .padding(.bottom,1)
            Text("2022.11.01개설 ‧ 1명")
                .font(.pretendardFont(.medium, size: 14))
                .foregroundColor(.greyScale3)
                .padding(.bottom, 32)
            
            VStack(spacing:8) {
                Text("초대코드")
                    .font(.pretendardFont(.medium, size: 12))
                    .foregroundColor(.greyScale8)
                Text("\(bookCode)")
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.greyScale2)
                    .background(Color.greyScale12)
                    .cornerRadius(12)
            }
            .padding(.horizontal,24)
            .onTapGesture {
                // 클립보드에 값 복사하기
                UIPasteboard.general.string = bookCode
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("초대 코드 복사"), message: Text("초대 코드가 복사되었습니다."), dismissButton: .default(Text("OK")))
            }
            Spacer()
            Button {
                
            } label: {
                Text("입장하기")
                    .padding(16)
                    .font(.pretendardFont(.bold,size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.primary1)
                    .cornerRadius(12)
                    
            }
            .padding(.horizontal,20)
            
            
            
            
        }
    }
}

struct InviteBookView_Previews: PreviewProvider {
    static var previews: some View {
        InviteBookView()
    }
}
