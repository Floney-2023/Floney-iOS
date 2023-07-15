//
//  CategoryManagementView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct CategoryManagementView: View {
    var options = ["자산", "지출", "수입", "이체"]
    @State private var selectedOptions = 0
    @State var list = ["현금", "체크카드", "신용카드", "은행"]
    @State var state = [true, true, true, false]
    @State var isShowingAdd = false
    @Binding var isShowingEditCategory : Bool
    @State var editState = false
    @StateObject var viewModel = AddViewModel()
    var body: some View {
        ZStack {
            VStack {
                VStack{
                    HStack {
                        Image("back_button")
                            .onTapGesture {
                                isShowingEditCategory = false
                            }
                        Spacer()
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
                    .frame(height: 24)
                    .padding(.top, 0)
                    .padding(.bottom, 52)
                    .padding(.horizontal, 24)
                    
                    VStack(alignment:.leading, spacing: 0){
                        HStack{
                            VStack(alignment:.leading, spacing: 10) {
                                Text("분류 항목 관리")
                                    .font(.pretendardFont(.bold,size: 24))
                                    .foregroundColor(.greyScale1)
                                Text("저번 달 대비 1,000,000원을\n더 사용했어요")
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
                    
                    //.padding(.horizontal, 16)
                    /*
                     switch selectedOptions {
                     case 0:
                     
                     case 1:
                     
                     case 2:
                     
                     case 3:
                     
                     default:
                     
                     }
                     */
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.categories.indices, id: \.self) { i in
                                VStack(alignment: .leading) {
                                    Spacer()
                                    HStack(spacing:0) {
                                        
                                        if editState {
                                            if !state[i] {
                                                Image("icon_delete")
                                                    .onTapGesture {
                                                        viewModel.deleteCategoryName = viewModel.categories[i]
                                                        viewModel.deleteCategory()
                                                    }
                                            }
                                            
                                        }
                                        Text("\(list[i])")
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
                        /*
                        VStack(alignment: .leading) {
                            ForEach(viewModel.categories.indices, id: \.self) { i in
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text("\(viewModel.categories[i])")
                                        .font(.pretendardFont(.medium, size: 14))
                                        .foregroundColor(.greyScale2)
                                    Spacer()
                                    Divider()
                                        .foregroundColor(.greyScale11)
                                }.frame(height: 58)
                                
                            }
                        }*/
                    }
                    
                }
               // .padding(.horizontal, 24)
                Button {
                    isShowingAdd = true
                } label: {
                    Text("추가하기")
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                        .padding()
                }.frame(maxWidth: .infinity)
                    .background(Color.primary1)
            }
            .fullScreenCover(isPresented: $isShowingAdd) {
                AddCategoryView(isShowingAdd: $isShowingAdd)
            }
            .onAppear{
                viewModel.root = "지출"
                viewModel.getCategory()
            }
            .onChange(of: selectedOptions) { newValue in
                viewModel.root = options[newValue]
                viewModel.getCategory()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryManagementView(isShowingEditCategory: .constant(true))
    }
}
