//
//  MyPageView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @Binding var showingTabbar : Bool
    //var encryptionManager = CryptManager()
    var profileManager = ProfileManager.shared
    
    @State var isShowingBottomSheet = false
    @StateObject var viewModel = MyPageViewModel()
    @State var isShowingNotiView = false
    @State var currency = CurrencyManager.shared.currentCurrency
    var body: some View {
        NavigationView {
        ZStack {
            VStack(spacing:26) {
                HStack {
                    Text("마이페이지")
                        .padding(.horizontal, 4)
                        .font(.pretendardFont(.bold, size: 22))
                        .foregroundColor(.greyScale1)
                    
                    Spacer()
                    NavigationLink(destination: NotificationView(showingTabbar: $showingTabbar), isActive: $isShowingNotiView) {
                        Image("icon_notification")
                            .onTapGesture {
                                showingTabbar = false
                                isShowingNotiView = true
                            }
                    }
                    Image("icon_settings")
                    
                }.padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing:16) {
                        NavigationLink(destination: UserInformationView(viewModel: viewModel, showingTabbar: $showingTabbar)) {
                            HStack {
                                if let profileUrl = viewModel.profileUrl {
                                    let url = URL(string : profileUrl)
                                    KFImage(url)
                                        .placeholder { //플레이스 홀더 설정
                                            Image("")
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
                                        .frame(width: 36, height: 36) //resize
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(20)
                                } else {
                                    if let preview = viewModel.userPreviewImage36 {
                                        Image(uiImage: preview)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                            .frame(width: 36, height: 36)
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
                                            
                                    } else {
                                        Image("user_profile_36")
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
                                    }
                                }
                                

                                
                                VStack(alignment: .leading, spacing:5){
                                    Text("\(viewModel.nickname)")
                                        .font(.pretendardFont(.bold, size: 14))
                                        .foregroundColor(.greyScale2)
                                    
                                    Text("\(viewModel.email)")
                                        .font(.pretendardFont(.medium, size: 12))
                                        .foregroundColor(.greyScale3)
                                }
                                Spacer()
                                Image("forward_button")
                                    .padding(20)
                            }
                            .background(Color.primary10)
                            .cornerRadius(12)
                            
                        }
                        
                        if viewModel.subscribe {
                            Button("구독 내역 보기") {
                            }
                            .padding()
                            .font(.pretendardFont(.semiBold, size: 13))
                            .foregroundColor(.greyScale12)
                            .frame(maxWidth: .infinity)
                            .background(Color.greyScale2)
                            .cornerRadius(12)
                        } else {
                            HStack(spacing:12){
                                VStack {
                                    HStack {
                                        Text("앱스토어에서\n별점을 남겨주세요")
                                            .font(.pretendardFont(.bold, size: 14))
                                            .foregroundColor(.greyScale2)
                                        Spacer()
                                    }
                                    Spacer()
                                    Text("리뷰쓰기")
                                        .font(.pretendardFont(.regular, size: 12))
                                        .foregroundColor(.greyScale3)
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .background(Color.greyScale12)
                                .cornerRadius(12)
                                NavigationLink(destination: SubscriptionView()) {
                                    VStack {
                                        HStack {
                                            Text("월 3,800\(currency)으로\n더 많은 혜택을\n누려보세요!")
                                                .font(.pretendardFont(.bold, size: 14))
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        Spacer()
                                        Text("플랜보기")
                                            .font(.pretendardFont(.medium, size: 12))
                                            .foregroundColor(.background3)
                                        
                                    }
                                    .padding(20)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 150)
                                    .background(
                                        LinearGradient(
                                            stops: [
                                                Gradient.Stop(color: Color(red: 0.6, green: 0.9, blue: 0.79), location: 0.00),
                                                Gradient.Stop(color: Color(red: 0.24, green: 0.91, blue: 0.67), location: 1.00),
                                            ],
                                            startPoint: UnitPoint(x: 0.96, y: 0.03),
                                            endPoint: UnitPoint(x: 0.05, y: 1)
                                        )
                                    )
                                    .cornerRadius(12)
                                    
                                }
                            }
                        }
                    }
                    
                    VStack(spacing:22) {
                        HStack {
                            Text("내 가계부")
                                .font(.pretendardFont(.bold, size: 16))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        
                        VStack(spacing:16) {
                            ForEach(viewModel.myBooks, id:\.self) { book in
                                HStack {
                                    
                                    if let bookUrl = book.bookImg {
                                        //let url = encryptionManager.decrypt(bookUrl, using: encryptionManager.key!)
                                        let url = URL(string : bookUrl)
                                        KFImage(url)
                                            .placeholder { //플레이스 홀더 설정
                                                Image("")
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
                                            .frame(width: 36, height: 36) //resize
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
                                        /*
                                        URLImage(url: URL(string: bookUrl))
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .frame(width: 36, height: 36)
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)*/
                                    } else {
                                        Image("book_profile_36")
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
                                    }
                                    
                                    
                                    VStack(alignment: .leading, spacing:5){
                                        Text("\(book.name)")
                                            .font(.pretendardFont(.bold, size: 14))
                                            .foregroundColor(.greyScale2)
                                        
                                        Text("\(book.memberCount)명")
                                            .font(.pretendardFont(.medium, size: 12))
                                            .foregroundColor(.greyScale6)
                                    }
                                    Spacer()
                                    Image("icon_check_circle")
                                        .padding(20)
                                }
                                .background(Color.greyScale12)
                                .cornerRadius(12)
                            }
                            
                            
                            // MARK: Bottom Sheet Toggle
                            Button(action: {
                                withAnimation{
                                    isShowingBottomSheet.toggle()
                                }
                            }) {
                                Image("icon_plus")
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.greyScale9, style:StrokeStyle(lineWidth: 1, dash: [6]))
                            )
                        }
                    }
                    VStack(spacing:30) {
                        HStack {
                            Text("고객지원")
                                .font(.pretendardFont(.bold, size: 16))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        HStack {
                            Text("문의하기")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                        HStack {
                            Text("공지사항")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                        HStack {
                            Text("리뷰 작성하기")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                        HStack {
                            Text("개인정보 처리방침")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                        HStack {
                            Text("이용 약관")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                            Spacer()
                            Image("forward_button")
                        }
                    }
                    
                    if viewModel.subscribe {
                        NavigationLink(destination: ServiceAgreementView()){
                            HStack {
                                VStack {
                                    Text("구독 해지")
                                        .font(.pretendardFont(.regular, size: 12))
                                        .foregroundColor(.greyScale6)
                                    Divider()
                                        .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                        .frame(width: 50,height: 1.0)
                                        .foregroundColor(.greyScale6)
                                    
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal,20)
            }
                
            }
            .padding(.top, 26)
            .onAppear{
                viewModel.getMyPage()
                showingTabbar = true
            }
            // MARK: Bottom Sheet
            //BottomSheet(isShowing: $isShowingBottomSheet, content: BottomSheetType.accountBook.view())
            AccountBookBottomSheet(isShowing: $isShowingBottomSheet, showingTabbar: $showingTabbar)
        }
    }
}


struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showingTabbar: .constant(true))
    }
}
