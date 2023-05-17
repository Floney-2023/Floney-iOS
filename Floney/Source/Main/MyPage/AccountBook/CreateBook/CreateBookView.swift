//
//  CreateBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import SwiftUI

struct CreateBookView: View {
    var pageCount = 3
    var pageCountAll = 3
    @State var bookTitle = ""
    @State var isShowingBottomSheet = false

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                        
                        Text("가계부가 생성되었어요!")
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
                
                VStack(spacing: 12) {
                    NavigationLink(destination: MainTabView()){
                        Text("작성하러 가기")
                            .padding()
                            .withNextButtonFormmating(.primary1)
                    }
                    Text("친구 초대하기")
                        .padding()
                        .foregroundColor(.primary1)
                        .withNextButtonFormmating(.primary9)
                        .onTapGesture {
                            self.isShowingBottomSheet.toggle()
                        }
                }
            }
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 40, trailing: 24))
            .navigationBarBackButtonHidden(true)
            //.navigationBarItems(leading: BackButton())
            
            // MARK: Bottom Sheet
            BottomSheet(isShowing: $isShowingBottomSheet, content: BottomSheetType.shareBook.view())
        }     
    }
}

struct CreateBookView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBookView()
    }
}
