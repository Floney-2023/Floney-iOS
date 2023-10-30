//
//  AddCategoryView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct AddCategoryView: View {
    let scaler = Scaler.shared
    @Binding var isShowingAdd : Bool
    @State var selectedIndex = 0
    let root = ["자산", "지출","수입","이체"]
    @State var text = ""
    @ObservedObject var alertManager = AlertManager.shared
    
    @ObservedObject var viewModel : AddViewModel
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    VStack(spacing:scaler.scaleHeight(12)) {
                        HStack {
                            Text("카테고리")
                                .font(.pretendardFont(.medium, size:scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale3)
                            Spacer()
                        }
                        VStack(spacing:scaler.scaleWidth(8)) {
                            HStack(spacing:scaler.scaleWidth(8)) {
                                Button {
                                    selectedIndex = 0
                                } label: {
                                    Text("자산")
                                        .frame(maxWidth: .infinity)
                                        .font(.pretendardFont(selectedIndex == 0 ? .bold : .regular, size: scaler.scaleWidth(14)))
                                        .foregroundColor(selectedIndex == 0 ? .white : .greyScale7)
                                        .padding()
                                }.frame(maxWidth: .infinity)
                                    .background(selectedIndex == 0 ? Color.black : Color.background1)
                                    .cornerRadius(12)
                                
                                Button {
                                    selectedIndex = 1
                                } label: {
                                    Text("지출")
                                        .frame(maxWidth: .infinity)
                                        .font(.pretendardFont(selectedIndex == 1 ? .bold : .regular, size: scaler.scaleWidth(14)))
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
                                        .frame(maxWidth: .infinity)
                                        .font(.pretendardFont(selectedIndex == 2 ? .bold : .regular, size: scaler.scaleWidth(14)))
                                        .foregroundColor(selectedIndex == 2 ? .white : .greyScale7)
                                        .padding()
                                }
                                .frame(maxWidth: .infinity)
                                .background(selectedIndex == 2 ? Color.black : Color.background1)
                                .cornerRadius(12)
                                
                                Button {
                                    selectedIndex = 3
                                } label: {
                                    Text("이체")
                                        .frame(maxWidth: .infinity)
                                        .font(.pretendardFont(selectedIndex == 3 ? .bold : .regular, size: scaler.scaleWidth(14)))
                                        .foregroundColor(selectedIndex == 3 ? .white : .greyScale7)
                                        .padding()
                                }
                                .frame(maxWidth: .infinity)
                                .background(selectedIndex == 3 ? Color.black : Color.background1)
                                .cornerRadius(12)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom,scaler.scaleHeight(41))
                    
                    VStack(spacing:scaler.scaleHeight(12)) {
                        HStack {
                            Text("항목 이름")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        CustomTextField(text: $viewModel.newCategoryName, placeholder: "이름을 입력하세요.", placeholderColor: .greyScale7)
                            .frame(height: scaler.scaleHeight(46))
                        
                        HStack {
                            Text("* 최대 6자까지 쓸 수 있어요.")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                            Spacer()
                        }.padding(.top, scaler.scaleHeight(2))
                    }
                    Spacer()
                    
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.top, scaler.scaleHeight(46))
                
                Button {
                    if viewModel.isValidCategoryName() {
                        viewModel.root = self.root[selectedIndex]
                        viewModel.postCategory()
                        isShowingAdd = false
                        
                    }
                    
                } label: {
                    Text("완료하기")
                        .frame(maxWidth: .infinity)
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                        .foregroundColor(.white)
                        .frame(height:scaler.scaleHeight(66))
                        .padding(.bottom, scaler.scaleHeight(10))
                }
                .edgesIgnoringSafeArea(.bottom)
                .frame(maxWidth: .infinity)
                .frame(height:scaler.scaleHeight(66))
                .background(Color.greyScale2)
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .customNavigationBar(
                centerView: {
                    Text("항목 추가")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                        .foregroundColor(.greyScale1)
                },
                rightView: {
                    Image("icon_close")
                        .onTapGesture {
                            isShowingAdd = false
                        }
                }
            )

            .onAppear(perform : UIApplication.shared.hideKeyboard)
            
            if AlertManager.shared.showAlert {
                CustomAlertView(message: alertManager.message, type: $alertManager.buttontType, isPresented: $alertManager.showAlert)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryView(isShowingAdd: .constant(true), viewModel: AddViewModel())
    }
}
