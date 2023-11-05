//
//  SettingBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI
import Kingfisher

struct SettingBookView: View {
    let scaler = Scaler.shared
    @GestureState private var dragOffset: CGSize = .zero
    @Binding var showingTabbar : Bool
    @Binding var isOnSettingBook : Bool
    @StateObject var viewModel = SettingBookViewModel()
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
    
    @State var resetAlert = false
    @State var resetTitle = "가계부 초기화"
    @State var resetMessage = "가계부 내역 초기화 시 모든 내역이 삭제됩니다. 초기화 하시겠습니까?"
    @State var exitAlert = false
    @State var exitTitle = "가계부 나가기"
    @State var exitMessage = "가계부를 나갈 시 모든 내역이 삭제됩니다. 삭제하시겠습니까?"
    
    @State var isShowingEditCategory = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing:scaler.scaleHeight(24)) {
                    VStack(spacing:scaler.scaleHeight(24)) {
                        //MARK: Head
                        HStack {
                            Text("가계부 설정")
                                .padding(.horizontal, scaler.scaleWidth(4))
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        
                        //MARK: 가계부 정보
                        NavigationLink(destination: ModifyingBookView(viewModel: viewModel)) {
                            HStack(spacing:scaler.scaleWidth(16)) {
                                if let bookUrl = viewModel.bookImg {
                                    let url = URL(string : bookUrl)
                                    KFImage(url)
                                        .placeholder { //플레이스 홀더 설정
                                            Image("book_profile_36")
                                            
                                        }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                                        .onSuccess { success in //성공
                                            print("succes: \(success)")
                                        }
                                        .onFailure { error in //실패
                                            print("failure: \(error)")
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                        .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36)) //resize
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                } else {
                                    Image("book_profile_36")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                        .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36)) //resize
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                }
                                VStack(alignment: .leading, spacing:scaler.scaleHeight(8)){
                                    Text("\(viewModel.bookName)")
                                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale2)
                                    
                                    Text("\(viewModel.startDay)")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale3)
                                }
                                Spacer()
                                Image("forward_button")
                            }
                            .padding(scaler.scaleWidth(20))
                            .background(Color.primary10)
                            .cornerRadius(12)
                        } // Navigation link
                    }
                    .padding(.bottom, scaler.scaleHeight(8))
                    
                    //MARK: 사용자 목록
                    VStack(spacing:scaler.scaleHeight(20)) {
                        HStack {
                            Text("사용자")
                                .padding(.horizontal, scaler.scaleWidth(4))
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        VStack(spacing:scaler.scaleHeight(32)) {
                            ForEach(viewModel.bookUsers.indices, id: \.self) { index in
                                HStack(spacing:scaler.scaleWidth(16)) {
                                    if let userImg = viewModel.userImages {
                                        if userImg[index] == "user_default" {
                                            Image("user_profile_32")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            
                                        } else if userImg[index].hasPrefix("random"){
                                            
                                            let components = userImg[index].components(separatedBy: CharacterSet.decimalDigits.inverted)
                                            let random = components.first!  // "random"
                                            let number = components.last!   // "5"
                                            Image("img_user_random_profile_0\(number)_32")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        }
                                        else {
                                            let url = URL(string : userImg[index])
                                            KFImage(url)
                                                .placeholder { //플레이스 홀더 설정
                                                    Image("user_profile_32")
                                                }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                                                .onSuccess { success in //성공
                                                    print("succes: \(success)")
                                                }
                                                .onFailure { error in //실패
                                                    print("failure: \(error)")
                                                }
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                                
                                        }
                                    } else {
                                        Image("user_profile_32")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                            .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                    }
                                    
                                    
                                    VStack(alignment: .leading, spacing:scaler.scaleHeight(8)){
                                        Text("\(viewModel.bookUsers[index].name)")
                                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                        
                                        if viewModel.bookUsers[index].me {
                                            Text("\(viewModel.bookUsers[index].role)·나")
                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                .foregroundColor(.greyScale6)
                                        } else {
                                            Text("\(viewModel.bookUsers[index].role)")
                                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                .foregroundColor(.greyScale6)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding(scaler.scaleWidth(20))
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, scaler.scaleHeight(16))
                    
                    //MARK: 캘린더
                    VStack(spacing:scaler.scaleHeight(14)) {
                        HStack {
                            Text("캘린더")
                                .font(.pretendardFont(.bold,size:scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        
                        HStack {
                            Text("이월 설정")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            if viewModel.carryOver {
                                Text("이월 있음")
                                    .padding(scaler.scaleWidth(6))
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(10)))
                                    .foregroundColor(.primary2)
                                    .background(Color.primary10)
                                    .cornerRadius(8)
                            } else {
                                Text("이월 없음")
                                    .padding(scaler.scaleWidth(6))
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(10)))
                                    .foregroundColor(.greyScale2)
                                    .background(Color.background2)
                                    .cornerRadius(8)
                            }
                        }
                        .frame(height:scaler.scaleHeight(46))
                        .onTapGesture {
                            self.isShowingCarriedOver.toggle()
                        }

                        if viewModel.role == "방장" {
                            HStack {
                                VStack(spacing:0) {
                                    Text("가계부 초기화하기")
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale6)
                                    
                                    Rectangle()
                                      .foregroundColor(.clear)
                                      .frame(width: scaler.scaleWidth(86), height: scaler.scaleWidth(0.5))
                                      .background(Color.greyScale6)
                                }
                                Spacer()
                            }
                            .padding(.top, scaler.scaleHeight(2))
                            .onTapGesture {
                                self.resetAlert = true
                            }
                        }
                    }
                    .padding(.horizontal, scaler.scaleWidth(4))
                    .padding(.bottom, scaler.scaleHeight(14))
                    
                    //MARK: 예산 자산
                    VStack(spacing:scaler.scaleHeight(14)) {
                        HStack {
                            Text("예산·자산")
                                .font(.pretendardFont(.bold,size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        VStack(spacing:0){
                            NavigationLink(destination :SetBudgetView(), isActive: $isShowingSetBudget) {
                                HStack {
                                    Text("예산 설정")
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale2)
                                    Spacer()
                                }
                                .frame(height:scaler.scaleHeight(46))
                                .onTapGesture {
                                    self.isShowingSetBudget.toggle()
                                }
                            }
                            HStack {
                                Text("초기 자산 설정")
                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                                Spacer()
                            }
                            .frame(height:scaler.scaleHeight(46))
                            .onTapGesture {
                                self.isShowingSetInitialAsset.toggle()
                            }
                        }
                        
                    }
                    .padding(.horizontal, scaler.scaleWidth(4))
                    
                    VStack(spacing:scaler.scaleHeight(18)) {
                        NavigationLink(destination: CategoryManagementView(isShowingEditCategory: $isShowingEditCategory)) {
                            HStack {
                                Text("분류항목 관리")
                                    .font(.pretendardFont(.bold,size: scaler.scaleWidth(16)))
                                    .foregroundColor(.greyScale1)
                                Spacer()
                                Image("forward_button")
                                
                            }
                            .frame(height:scaler.scaleHeight(48))
                        }
                        if viewModel.role == "방장" {
                            NavigationLink(destination: SetCurrencyUnitView()){
                                HStack {
                                    Text("화폐 설정")
                                        .font(.pretendardFont(.bold,size: scaler.scaleWidth(16)))
                                        .foregroundColor(.greyScale1)
                                    Spacer()
                                    Image("forward_button")
                                    
                                }
                                .frame(height:scaler.scaleHeight(48))
                            }
                        }
                        
                        HStack {
                            Text("엑셀 내보내기")
                                .font(.pretendardFont(.bold,size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                            Image("forward_button")
                        }
                        .frame(height:scaler.scaleHeight(48))
                        .onTapGesture {
                            viewModel.downloadExcelFile()
                        }
                        
                        HStack {
                            Text("친구 초대하기")
                                .font(.pretendardFont(.bold,size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                            Image("forward_button")
                        }
                        .frame(height:scaler.scaleHeight(48))
                        .onTapGesture {
                            self.isShowingShareBook.toggle()
                        }

                    }
                    .padding(.horizontal, scaler.scaleWidth(4))
                    
                    if viewModel.role == "팀원" {
                        //MARK: 가계부 나가기
                        HStack {
                            VStack(spacing:0) {
                                Text("가계부 나가기")
                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                    .foregroundColor(.greyScale6)
                                Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(width: scaler.scaleWidth(65), height: scaler.scaleWidth(0.5))
                                  .background(Color.greyScale6)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, scaler.scaleWidth(4))
                        .onTapGesture {
                            self.exitAlert = true
                            
                        }
                        
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: scaler.scaleHeight(30), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
                
            }
            .customNavigationBar(
                leftView: { BackButton() }
                )
            .onAppear{
                viewModel.getBookInfo()
            }
            .sheet(isPresented: $onShareSheet) {
                if let url = viewModel.shareUrl {
                    ActivityView(activityItems: [url])
                }
               
            }
            .sheet(isPresented: $viewModel.shareExcelStatus) {
               
                if let excelUrl = viewModel.excelURL {
                    ActivityView(activityItems: [excelUrl])
                }
            }
            .overlay(
                ZStack {
                    if exitAlert {
                        AlertView(isPresented: $exitAlert, title: $exitTitle, message: $exitMessage, okColor: .alertRed, onOKAction: {
                            DispatchQueue.main.async {
                                viewModel.exitBook()
                            }
                        })
                    }
                }
            )
            .overlay(
                ZStack {
                    if resetAlert {
                        AlertView(isPresented: $resetAlert,title: $resetTitle, message: $resetMessage, okColor: .alertRed, onOKAction: {
                            DispatchQueue.main.async {
                                viewModel.resetBook()
                            }
                        })
                    }
                }
            )
            SetInitialAssetBottomSheet(isShowing: $isShowingSetInitialAsset, viewModel: viewModel)
            
            CarriedOverBottomSheet(isShowing: $isShowingCarriedOver, viewModel:viewModel)
            
            ShareBookBottomSheet(viewModel: viewModel, isShowing: $isShowingShareBook, onShareSheet: $onShareSheet)
        }
 
    }
}


struct SettingBookView_Previews: PreviewProvider {
    static var previews: some View {
        SettingBookView(showingTabbar: .constant(false), isOnSettingBook: .constant(true))
    }
}
