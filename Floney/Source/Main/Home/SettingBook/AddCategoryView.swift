//
//  AddCategoryView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AddCategoryView: View {
    @Binding var isShowingAdd : Bool
    @State var selectedIndex = 0
    let root = ["자산", "지출","수입","이체"]
    @State var text = ""
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Spacer()
                    Text("항목 추가")
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale1)
                    
                    Spacer()
                    Image("icon_close")
                        .onTapGesture {
                            isShowingAdd = false
                        }
                }.padding(.bottom, 50)
                
                VStack(spacing:12) {
                    HStack {
                        Text("카테고리")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale3)
                        Spacer()
                    }
                    VStack(spacing:8) {
                        HStack(spacing:8) {
                            Button {
                                selectedIndex = 0
                            } label: {
                                Text("자산")
                                    .font(.pretendardFont(selectedIndex == 0 ? .bold : .regular, size: 14))
                                    .foregroundColor(selectedIndex == 0 ? .white : .greyScale7)
                                    .padding()
                            }.frame(maxWidth: .infinity)
                                .background(selectedIndex == 0 ? Color.black : Color.background1)
                                .cornerRadius(12)
                            
                            Button {
                                selectedIndex = 1
                            } label: {
                                Text("지출")
                                    .font(.pretendardFont(selectedIndex == 1 ? .bold : .regular, size: 14))
                                    .foregroundColor(selectedIndex == 1 ? .white : .greyScale7)
                                    .padding()
                            }.frame(maxWidth: .infinity)
                                .background(selectedIndex == 1 ? Color.black : Color.background1)
                                .cornerRadius(12)
                        }.frame(maxWidth: .infinity)
                        HStack(spacing:8) {
                            Button {
                                selectedIndex = 2
                            } label: {
                                Text("수입")
                                    .font(.pretendardFont(selectedIndex == 2 ? .bold : .regular, size: 14))
                                    .foregroundColor(selectedIndex == 2 ? .white : .greyScale7)
                                    .padding()
                            }.frame(maxWidth: .infinity)
                                .background(selectedIndex == 2 ? Color.black : Color.background1)
                                .cornerRadius(12)
                            
                            Button {
                                selectedIndex = 3
                            } label: {
                                Text("이체")
                                    .font(.pretendardFont(selectedIndex == 3 ? .bold : .regular, size: 14))
                                    .foregroundColor(selectedIndex == 3 ? .white : .greyScale7)
                                    .padding()
                            }.frame(maxWidth: .infinity)
                                .background(selectedIndex == 3 ? Color.black : Color.background1)
                                .cornerRadius(12)
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
                    .padding(.bottom, 41)
                
                VStack(spacing:12) {
                    HStack {
                        Text("항목 이름")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    TextField("", text: $text)
                        .padding()
                        .overlay(
                            Text("이름을 입력하세요.")
                                .padding()
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale7)
                                .opacity(text.isEmpty ? 1 : 0), alignment: .leading
                        )
                        .modifier(TextFieldModifier())
                    HStack {
                        Text("* 최대 6자까지 쓸 수 있어요.")
                            .font(.pretendardFont(.regular, size: 12))
                            .foregroundColor(.greyScale6)
                        Spacer()
                    }.padding(.top, 2)
                }
                
                Spacer()
            }.padding(.horizontal, 20)
                .padding(.top, 18)
            Button {
                isShowingAdd = true
            } label: {
                Text("완료하기")
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .padding()
            }.frame(maxWidth: .infinity)
                .background(Color.greyScale2)

        }
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(isShowingAdd: .constant(true))
    }
}
