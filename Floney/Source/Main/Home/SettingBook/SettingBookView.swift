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
    var encryptionManager = CryptManager()
    var profileManager = ProfileManager.shared
    
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
    
    @State var resetAlert = false
    @State var resetTitle = "가계부 초기화"
    @State var resetMessage = "가계부 내역 초기화 시 모든 내역이 삭제됩니다. 초기화 하시겠습니까?"
    @State var exitAlert = false
    @State var exitTitle = "가계부 나가기"
    @State var exitMessage = "가계부를 나갈 시 모든 내역이 삭제됩니다. 삭제하시겠습니까?"
    
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
                        NavigationLink(destination: ModifyingBookView()) {
                            HStack(spacing:16) {
                                /*
                                Image("book_profile_36")
                                    .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))*/
                                if let bookUrl = viewModel.bookImg {
                                    let url = encryptionManager.decrypt(bookUrl, using: encryptionManager.key!)
                                    URLImage(url: URL(string: url!)!)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 36, height: 36)
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                } else {
                                    Image("book_profile_36")
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))

                                }
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
                            ForEach(viewModel.bookUsers.indices, id: \.self) { index in
                                HStack(spacing:16) {
                                    if let userImg = viewModel.userImages {
                                        if userImg[index] == "user_default" {
                                            Image("user_profile_32")
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                
                                        } else if userImg[index].hasPrefix("random"){
                                            let components = userImg[index].components(separatedBy: CharacterSet.decimalDigits.inverted)
                                            let random = components.first!  // "random"
                                            let number = components.last!   // "5"
                                            Image("img_user_random_profile_0\(number)_32")
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        }
                                        else {
                                            let url = encryptionManager.decrypt(userImg[index], using: encryptionManager.key!)
                                            URLImage(url: URL(string: url!)!)
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width: 34, height: 34)
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                               
                                        }
                                    } else {
                                        Image("user_profile_32")
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            
                                    }

                        
                                    VStack(alignment: .leading, spacing:8){
                                        Text("\(viewModel.bookUsers[index].name)")
                                            .font(.pretendardFont(.bold, size: 14))
                                            .foregroundColor(.greyScale2)
                                        
                                        if viewModel.bookUsers[index].me {
                                            Text("\(viewModel.bookUsers[index].role)·나")
                                                .font(.pretendardFont(.medium, size: 12))
                                                .foregroundColor(.greyScale6)
                                        } else {
                                            Text("\(viewModel.bookUsers[index].role)")
                                                .font(.pretendardFont(.medium, size: 12))
                                                .foregroundColor(.greyScale6)
                                        }
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
                            if viewModel.carryOver {
                                Text("이월 있음")
                                    .padding(6)
                                    .font(.pretendardFont(.medium, size: 10))
                                    .foregroundColor(.primary2)
                                    .background(Color.primary10)
                                    .cornerRadius(8)
                            } else {
                                Text("이월 없음")
                                    .padding(6)
                                    .font(.pretendardFont(.medium, size: 10))
                                    .foregroundColor(.greyScale2)
                                    .background(Color.background2)
                                    .cornerRadius(8)
                            }
                        }
                        .onTapGesture {
                            self.isShowingCarriedOver.toggle()
                        }
                        if viewModel.role == "방장" {
                            
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
                            .onTapGesture {
                                self.resetAlert = true
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
                    if viewModel.role == "팀원" {
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
                        .onTapGesture {
                            self.exitAlert = true
                        }
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: BackButton())
                .onAppear{
                    viewModel.getBookInfo()
                 
                }
                
                
            }.sheet(isPresented: $onShareSheet) {
                ActivityView(activityItems: [shareUrl ?? ""])
            }
            .overlay(
                ZStack {
                    if exitAlert {
                        AlertView(isPresented: $exitAlert, title: $exitTitle, message: $exitMessage, okColor: .alertRed, onOKAction: {
                            viewModel.exitBook()
                        })
                    }
                }
            )
            .overlay(
                ZStack {
                    if resetAlert {
                        AlertView(isPresented: $resetAlert,title: $resetTitle, message: $resetMessage, okColor: .alertRed, onOKAction: {
                            
                        })
                    }
                }
            )
            
            SetBudgetBottomSheet(isShowing: $isShowingSetBudget, viewModel: viewModel)
            
            SetInitialAssetBottomSheet(isShowing: $isShowingSetInitialAsset, viewModel: viewModel)
            
            CarriedOverBottomSheet(isShowing: $isShowingCarriedOver, onOff: $viewModel.carryOver)
            
            ShareBookBottomSheet(viewModel: viewModel, isShowing: $isShowingShareBook, bookCode: $bookCode, onShareSheet: $onShareSheet, shareUrl: $shareUrl)
                
            //BottomSheet(isShowing: $isShowingShareBook, content: BottomSheetType.shareBook.view())
        }
        
        
    }
    
    
}


struct SettingBookView_Previews: PreviewProvider {
    static var previews: some View {
        SettingBookView(isOnSettingBook: .constant(true))
    }
}
