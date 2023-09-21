//
//  CategoryManagementView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct CategoryManagementView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var options = ["자산", "지출", "수입", "이체"]
    @State private var selectedOptions = 0
    @State var list = ["현금", "체크카드", "신용카드", "은행"]
    @State var state = [true, true, true, false]
    @State var isShowingAdd = false
    @Binding var isShowingEditCategory : Bool
    @State var editState = false
    @StateObject var viewModel = AddViewModel()
    @State var deleteAlert = false
    @State var title = "분류항목 삭제"
    @State var message = "삭제하시겠습니까?"
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    VStack(alignment:.leading, spacing: 0){
                        HStack{
                            VStack(alignment:.leading, spacing: 10) {
                                Text("분류 항목 관리")
                                    .font(.pretendardFont(.bold,size: 24))
                                    .foregroundColor(.greyScale1)
                                Text("가계부를 적을 때 선택하는 항목들을\n추가, 삭제 할 수 있어요")
                                    .font(.pretendardFont(.medium,size: 13))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            Image("category_management")
                            
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    HStack(spacing: 0) {
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color.greyScale12)
                                
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(6)
                                    .padding(4)
                                    .opacity(selectedOptions == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            selectedOptions = index
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                                
                                    .font(.pretendardFont(.semiBold, size: 14))
                                    .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .cornerRadius(8)
                    .padding(.horizontal,20)

                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.categories.indices, id: \.self) { i in
                                VStack(alignment: .leading) {
                                    Spacer()
                                    HStack(spacing:0) {
                                        
                                        if editState {
                                            if !(viewModel.categoryStates[i]) {
                                                Image("icon_delete")
                                                    .onTapGesture {
                                                        viewModel.deleteCategoryName = viewModel.categories[i]
                                                        self.deleteAlert = true
                                                    }
                                            }
                                        }
                                        Text("\(viewModel.categories[i])")
                                            .padding(.leading,12)
                                            .font(.pretendardFont(.medium, size: 14))
                                            .foregroundColor(.greyScale2)
                                    }
                                    Spacer()
                                    Divider()
                                        .foregroundColor(.greyScale11)
                                }.frame(height: 58)
                                
                            }
                            
                        }.padding(.horizontal,22)
                            .padding(.bottom, 64)
                    }
                } // VStack
            } // VStack
            .fullScreenCover(isPresented: $isShowingAdd) {
                AddCategoryView(isShowingAdd: $isShowingAdd, viewModel: viewModel)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                viewModel.root = "자산"
                viewModel.getCategory()
            }
            .onChange(of: selectedOptions) { newValue in
                viewModel.root = options[newValue]
                viewModel.getCategory()
            }
            .onChange(of: isShowingAdd) { newValue in
                viewModel.getCategory()
            }
            .customNavigationBar(
                leftView: {
                Image("back_button")
                    .onTapGesture {
                        isShowingEditCategory = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                },
                rightView: {
                    Group {
                        if editState {
                            Button {
                                self.editState = false
                            } label: {
                                Text("완료")
                                    .font(.pretendardFont(.regular,size: 14))
                                    .foregroundColor(.greyScale2)
                            }
                            
                        } else {
                            Image("icon_edit")
                                .onTapGesture {
                                    self.editState = true
                                }
                        }
                    }
                }
            )
            VStack {
                Spacer()
                Button {
                    isShowingAdd = true
                } label: {
                    Text("추가하기")
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                }.frame(maxWidth: .infinity)
                    .frame(height:UIScreen.main.bounds.height * 0.085)
                    .background(Color.primary1)
            }.edgesIgnoringSafeArea(.bottom)
            
            if deleteAlert {
                AlertView(isPresented: $deleteAlert, title: $title, message: $message, onOKAction: {
                    viewModel.deleteCategory()
                })
            }
        }// ZStack
      
    }
}

struct CategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryManagementView(isShowingEditCategory: .constant(true))
    }
}
