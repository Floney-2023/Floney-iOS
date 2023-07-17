//
//  SettingBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI

struct SettingBookView: View {
    @Binding var isOnSettingBook : Bool
    @StateObject var viewModel = SettingBookViewModel()
    
    @State var nickname = "team"
    @State var date = "2023.05.01 개설"
    @State var isShowingSetBudget = false
    @State var isShowingSetInitialAsset = false
    @State var isShowingCarriedOver = false
    @State var isShowingShareBook = false
    @State var budget = ""
    @State var initialAsset = ""
    @State var onOff = false
    @State var onShareSheet = false
    @State var bookCode = "A9BC7ACE"
    @State private var shareUrl: URL? = nil
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing:32) {
                    VStack(spacing:24) {
                        //MARK: Head
                        HStack {
                            Text("가계부 설정")
                                .padding(.horizontal, 4)
                                .font(.pretendardFont(.bold, size: 22))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        
                        //MARK: 가계부 정보
                        NavigationLink(destination: ModifyingBookView(viewModel: viewModel)) {
                            HStack(spacing:16) {
                                Image("icon_profile_book")
                                
                                VStack(alignment: .leading, spacing:8){
                                    Text("\(viewModel.bookName)")
                                        .font(.pretendardFont(.bold, size: 14))
                                        .foregroundColor(.greyScale2)
                                    
                                    Text("\(viewModel.startDay)")
                                        .font(.pretendardFont(.medium, size: 12))
                                        .foregroundColor(.greyScale3)
                                }
                                Spacer()
                                Image("forward_button")
                                
                            }
                            .padding(20)
                            .background(Color.primary10)
                            .cornerRadius(12)
                        }
                    }
                    
                    //MARK: 사용자 목록
                    VStack(spacing:20) {
                        HStack {
                            Text("사용자")
                                .font(.pretendardFont(.bold, size: 16))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        VStack(spacing:32) {
                            ForEach(viewModel.bookUsers, id: \.self) { user in
                                HStack(spacing:16) {
                                    Image("icon_profile")
                                    
                                    VStack(alignment: .leading, spacing:8){
                                        Text("\(user.name)")
                                            .font(.pretendardFont(.bold, size: 14))
                                            .foregroundColor(.greyScale2)
                                        
                                        Text("\(user.role)")
                                            .font(.pretendardFont(.medium, size: 12))
                                            .foregroundColor(.greyScale6)
                                    }
                                    Spacer()
                                }

                            }

    
                        }
                        .padding(20)
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, 8)
                    
                    //MARK: 캘린더
                    VStack(spacing:30) {
                        HStack {
                            Text("캘린더")
                                .font(.pretendardFont(.bold,size: 16))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        HStack {
                            Text("이월 설정")
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Text("이월 없음")
                                .padding(6)
                                .font(.pretendardFont(.medium, size: 10))
                                .foregroundColor(.greyScale2)
                                .background(Color.background2)
                                .cornerRadius(8)
                        }
                        .onTapGesture {
                            self.isShowingCarriedOver.toggle()
                        }
                        if viewModel.role == "방장" {
                            NavigationLink(destination: FindPasswordView()){
                                HStack {
                                    VStack {
                                        Text("가계부 초기화")
                                            .font(.pretendardFont(.regular, size: 12))
                                            .foregroundColor(.greyScale6)
                                        
                                        Divider()
                                            .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                            .frame(width: 70,height: 1.0)
                                            .foregroundColor(.greyScale6)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    //MARK: 예산 자산
                    VStack(spacing:30) {
                        HStack {
                            Text("예산·자산")
                                .font(.pretendardFont(.bold,size: 16))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        HStack {
                            Text("예산 설정")
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        .onTapGesture {
                            self.isShowingSetBudget.toggle()
                        }
                        HStack {
                            Text("초기 자산 설정")
                            
                                .font(.pretendardFont(.regular, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                        }
                        .onTapGesture {
                            self.isShowingSetInitialAsset.toggle()
                        }
                        
                    }
                    HStack {
                        Text("분류항목 관리")
                            .font(.pretendardFont(.bold,size: 16))
                            .foregroundColor(.greyScale1)
                        Spacer()
                        Image("forward_button")
                        
                    }
                    if viewModel.role == "방장" {
                        HStack {
                            Text("화폐 설정")
                                .font(.pretendardFont(.bold,size: 16))
                                .foregroundColor(.greyScale1)
                            Spacer()
                            Image("forward_button")
                            
                        }
                    }
                    
                    HStack {
                        Text("엑셀 내보내기")
                            .font(.pretendardFont(.bold,size: 16))
                            .foregroundColor(.greyScale1)
                        Spacer()
                        Image("forward_button")
                    }
                    
                    HStack {
                        Text("친구 초대하기")
                            .font(.pretendardFont(.bold,size: 16))
                            .foregroundColor(.greyScale1)
                        Spacer()
                        Image("forward_button")
                    }
                    .onTapGesture {
                        self.isShowingShareBook.toggle()
                    }
                    
                    //MARK: 가계부 나가기
                    HStack {
                        VStack {
                            Text("가계부 나가기")
                                .font(.pretendardFont(.regular, size: 12))
                                .foregroundColor(.greyScale6)
                            
                            
                            Divider()
                                .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                .frame(width: 70,height: 1.0)
                                .foregroundColor(.greyScale6)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: BackButton(), trailing: Image("icon_notification"))
                .onAppear{
                    viewModel.getBookInfo()
                 
                }
            }.sheet(isPresented: $onShareSheet) {
                ActivityView(activityItems: [shareUrl ?? ""])
            }
            
            SetBudgetBottomSheet(isShowing: $isShowingSetBudget, viewModel: viewModel)
            
            SetInitialAssetBottomSheet(isShowing: $isShowingSetInitialAsset, viewModel: viewModel)
            
            CarriedOverBottomSheet(isShowing: $isShowingCarriedOver, onOff: $onOff)
            
            ShareBookBottomSheet(isShowing: $isShowingShareBook, bookCode: $bookCode, onShareSheet: $onShareSheet, shareUrl: $shareUrl)
                
            //BottomSheet(isShowing: $isShowingShareBook, content: BottomSheetType.shareBook.view())
        }
        
        
    }
    
    
}


struct SettingBookView_Previews: PreviewProvider {
    static var previews: some View {
        SettingBookView(isOnSettingBook: .constant(true))
    }
}
