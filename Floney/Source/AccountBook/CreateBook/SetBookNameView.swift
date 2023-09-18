//
//  CreateBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//

import SwiftUI

struct SetBookNameView: View {
    var pageCount = 1
    var pageCountAll = 3
    //@State var bookTitle = ""
    @StateObject var viewModel = CreateBookViewModel()
    @State var createBookType : createBookType = .initial
    @State var isActive = false
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                    
                    Text("가계부 생성하기")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("언제든지 멤버를 추가할 수 있는\n플로니의 가계부를 만들어 보세요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            VStack(spacing: 14) {
                CustomTextField(text: $viewModel.bookName, placeholder: "가계부 이름을 입력하세요",placeholderColor: .greyScale6)
                    .frame(height: UIScreen.main.bounds.height * 0.06)
                HStack {
                    Text("* 최대 10자까지 쓸 수 있어요.")
                        .font(.pretendardFont(.regular, size: 12))
                        .foregroundColor(.greyScale6)
                    Spacer()
                }
            }
            
            
            Spacer()
            
            NavigationLink(destination: SetBookProfileView(createBookType: $createBookType, viewModel: viewModel), isActive: $isActive){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        if viewModel.isVaildBookName() {
                            isActive = true
                        }
                    }
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .customNavigationBar(
            leftView: { BackButton() }
        )
        .onAppear(perform : UIApplication.shared.hideKeyboard)

    
    }
}

struct SetBookNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetBookNameView()
    }
}
