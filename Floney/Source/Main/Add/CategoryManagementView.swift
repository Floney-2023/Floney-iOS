//
//  CategoryManagementView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct CategoryManagementView: View {
    let scaler = Scaler.shared
    @Environment(\.presentationMode) var presentationMode
    var options = ["자산", "지출", "수입", "이체"]
    @State private var selectedOptions = 0
    @State var list = ["현금", "체크카드", "신용카드", "은행"]
    @State var state = [true, true, true, false]
    @State var isShowingAdd = false
    @Binding var isShowingEditCategory : Bool
    @State var editState = false
    @State var showEditButton = true
    @StateObject var viewModel = AddViewModel()
    @State var deleteAlert = false
    @State var title = "분류항목 삭제"
    @State var message = ""
    @State var modifyAlert = false
    @State var modifyTitle = "잠깐!"
    @State var modifyMessage = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
    @State var showAddButton = true
    
    @State private var secondsElapsed = 1
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                VStack(spacing:0) {
                    VStack(alignment:.leading, spacing: 0){
                        HStack{
                            VStack(alignment:.leading, spacing: scaler.scaleHeight(16)) {
                                Text("분류 항목 관리")
                                    .font(.pretendardFont(.bold,size:scaler.scaleWidth(24)))
                                    .foregroundColor(.greyScale1)
                                Text("가계부를 적을 때 선택하는 항목들을\n추가, 삭제 할 수 있어요")
                                    .lineSpacing(4)
                                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width:scaler.scaleWidth(86), height:scaler.scaleHeight(76))
                                .background(
                                    Image("category_management")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:scaler.scaleWidth(86), height:scaler.scaleHeight(76))
                      
                                )
                            
                        }
                    }
                    .padding(.horizontal,scaler.scaleWidth(24))
                    .padding(.bottom, scaler.scaleHeight(32))
                    
                    HStack(spacing: 0) {
                        ForEach(options.indices, id:\.self) { index in
                            ZStack {
                                Rectangle()
                                    .fill(Color.greyScale12)
                                Rectangle()
                                    .fill(Color.white)
                                    .cornerRadius(6)
                                    .padding(scaler.scaleWidth(4))
                                    .opacity(selectedOptions == index ? 1 : 0.01)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring()) {
                                            selectedOptions = index
                                        }
                                    }
                            }
                            .overlay(
                                Text(options[index])
                                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(14)))
                                    .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(38))
                    .cornerRadius(8)
                    .padding(.horizontal,scaler.scaleWidth(20))
                    if viewModel.categories.count == 0 {
                        VStack(spacing:scaler.scaleHeight(10)) {
                            Image("no_line")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: scaler.scaleWidth(38), height: scaler.scaleWidth(64))
                            Text("내역이 없습니다.")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                        }
                        .padding(.top, scaler.scaleHeight(156))
                        .onAppear {
                            self.showEditButton = false
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(viewModel.categories.indices, id: \.self) { i in
                                    VStack(alignment: .leading, spacing:0) {
                                        //Spacer()
                                        HStack(spacing:scaler.scaleWidth(12)) {
                                            if editState {
                                                
                                                Image("icon_delete")
                                                    .onTapGesture {
                                                        viewModel.deleteCategoryName = viewModel.categories[i]
                                                        message = "'\(viewModel.deleteCategoryName)' 항목을 삭제하시겠습니까?\n해당 항목으로 작성된 모든 내역이 삭제됩니다."
                                                        self.deleteAlert = true
                                                    }
                                                
                                            }
                                            Text("\(viewModel.categories[i])")
                                                .padding(.leading, scaler.scaleWidth(12))
                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                                .foregroundColor(.greyScale2)
                                        }
                                        .frame(height: scaler.scaleHeight(58))
                                        //Spacer()
                                        Divider()
                                            .foregroundColor(.greyScale11)
                                    }
                                    
                                }
                                
                            }
                            .padding(.top, scaler.scaleHeight(16))
                            .padding(.horizontal,scaler.scaleWidth(22))
                            .padding(.bottom,  scaler.scaleHeight(64))
                        }
                        .onAppear {
                            self.showEditButton = true
                        }
                    }
                } // VStack
                .padding(.top, scaler.scaleHeight(32))
            } // VStack
            .fullScreenCover(isPresented: $isShowingAdd) {
                AddCategoryView(isShowingAdd: $isShowingAdd, viewModel: viewModel)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                viewModel.root = "자산"
                viewModel.getCategory()
            }
            .onDisappear {
                stopTimer()
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
                Image("icon_back")
                    .onTapGesture {
                        if editState {
                            modifyAlert = true
                        } else {
                            isShowingEditCategory = false
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                rightView: {
                    Group {
                        if showEditButton {
                            Group {
                                if editState {
                                    Button {
                                        self.editState = false
                                        self.showAddButton = true
                                    } label: {
                                        Text("완료")
                                            .font(.pretendardFont(.regular,size:scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                    }
                                    
                                } else {
                                    Button {
                                        self.editState = true
                                        self.showAddButton = false
                                    } label: {
                                        Text("편집")
                                            .font(.pretendardFont(.regular,size:scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                    }
                                }
                            }
                        } else {
                            EmptyView()
                        }
                    }
                }
            )
            if showAddButton {
                VStack {
                    Spacer()
                    Button {
                        isShowingAdd = true
                    } label: {
                        Text("추가하기")
                            .frame(maxWidth: .infinity)
                            .frame(height:scaler.scaleHeight(66))
                            .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                            .foregroundColor(.white)
                            .padding(.bottom, scaler.scaleHeight(10))
                    }
                        .frame(maxWidth: .infinity)
                        .frame(height:scaler.scaleHeight(66))
                        .background(Color.primary1)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            
            if deleteAlert {
                FloneyAlertView(isPresented: $deleteAlert, title:$title, message: $message, leftButtonText:"삭제하기") {
                    viewModel.deleteCategory()
                    startTimer()
                }
                
            }
            //MARK: alert
            if modifyAlert {
                AlertView(isPresented: $modifyAlert, title: $modifyTitle, message: $modifyMessage) {
                    isShowingEditCategory = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            if viewModel.isApiCalling {
                CircularProgressView()
            }
            
        }// ZStack
      
    }
    func startTimer() {
        secondsElapsed = 1
        timer?.invalidate() // 기존 타이머가 있다면 중지
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                self.secondsElapsed += 1
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct CategoryManagementView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryManagementView(isShowingEditCategory: .constant(true))
    }
}

