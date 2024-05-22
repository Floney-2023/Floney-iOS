//
//  ManageFavoriteLineView.swift
//  Floney
//
//  Created by 남경민 on 5/21/24.
//

import SwiftUI

struct ManageFavoriteLineView: View {
    let scaler = Scaler.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedOptions = 0
    @State private var selectedFavoriteLineId = 0
    var options = ["지출", "수입", "이체"]
    @Binding var isShowing : Bool
    @State var editState = false
    @StateObject var viewModel = ManageFavoriteLineViewModel()
    @State var deleteAlert = false
    @State var title = "삭제하기"
    @State var message = "삭제하시겠습니까?"
    @State private var secondsElapsed = 1
    @State private var timer: Timer?
    @State var showAddButton = true
    @State var isShowingAdd = false
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                VStack(spacing:0) {
                    VStack(alignment:.leading, spacing: 0){
                        HStack{
                            VStack(alignment:.leading, spacing: scaler.scaleHeight(16)) {
                                Text("즐겨찾기")
                                    .font(.pretendardFont(.bold,size:scaler.scaleWidth(24)))
                                    .foregroundColor(.greyScale1)
                                Text("자주 사용하는 내역을\n즐겨찾기로 편하게 기록해 보세요")
                                    .lineSpacing(4)
                                    .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width:scaler.scaleWidth(76), height:scaler.scaleHeight(76))
                                .background(
                                    Image("illust_favorites")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:scaler.scaleWidth(76), height:scaler.scaleHeight(76))
                      
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
                    
                    if viewModel.favoriteLineList.count == 0 {
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
                    }
                    else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .leading) {
                                ForEach(viewModel.favoriteLineList, id: \.self) { (favoriteLine:FavoriteLineResponse) in
                                    VStack(alignment: .leading, spacing:0) {
                                        HStack(spacing:scaler.scaleWidth(12)) {
                                            if editState {
                                                Image("icon_delete")
                                                    .onTapGesture {
                                                        selectedFavoriteLineId = favoriteLine.id
                                                        self.deleteAlert = true
                                                    }
                                            }
                                            VStack(alignment: .leading, spacing:8) {
                                                Text("\(favoriteLine.description)")
                                                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                                    .foregroundColor(.greyScale2)
                                                HStack(spacing:0) {
                                                    Text("\(favoriteLine.assetSubcategoryName)")
                                                    Text(" ‧ ")
                                                    Text("\(favoriteLine.lineSubcategoryName)")
                                                }
                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                .foregroundColor(.greyScale6)
                                            }
                                            .padding(.leading, scaler.scaleWidth(12))
                                            Spacer()
                                            Text(favoriteLine.money.formattedString)
                                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                                .padding(.trailing, scaler.scaleWidth(12))
                                        }
                                        .frame(height: scaler.scaleHeight(66))
                                        Divider()
                                            .foregroundColor(.greyScale11)
                                    }
                                }
                            }
                            .padding(.top, scaler.scaleHeight(16))
                            .padding(.horizontal,scaler.scaleWidth(22))
                            .padding(.bottom,  scaler.scaleHeight(64))
                        }
                    }
                } // VStack
                .padding(.top, scaler.scaleHeight(32))
            } // VStack
            .fullScreenCover(isPresented: $isShowingAdd) {
                AddFavoriteLineView(viewModel: viewModel,isPresented: $isShowingAdd)
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                viewModel.categoryType = "OUTCOME"
                viewModel.getFavoriteLine()
            }
            .onDisappear {
                stopTimer()
            }
            .onChange(of: selectedOptions) { newValue in
                if options[newValue] == "지출" {
                    viewModel.categoryType = "OUTCOME"
                } else if options[newValue] == "수입"{
                    viewModel.categoryType = "INCOME"
                } else if options[newValue] == "이체"{
                    viewModel.categoryType = "TRANSFER"
                }
                viewModel.getFavoriteLine()
            }
            .customNavigationBar(
                leftView: {
                    Image("icon_back")
                        .onTapGesture {
                            isShowing = false
                            self.presentationMode.wrappedValue.dismiss()
                                                }
                },
                rightView: {
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
                AlertView(isPresented: $deleteAlert, title: $title, message: $message, okColor: .alertBlue) {
                    viewModel.deleteFavoriteLine(favoriteLineId: selectedFavoriteLineId)
                }
            }
        }
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

#Preview {
    ManageFavoriteLineView(isShowing: .constant(true))
}
