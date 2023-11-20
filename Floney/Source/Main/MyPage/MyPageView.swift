//
//  MyPageView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    let scaler = Scaler.shared
    @Binding var showingTabbar : Bool
    var profileManager = ProfileManager.shared
    @Binding var isShowingAccountBottomSheet : Bool
    @Binding var isNextToCreateBook : Bool
    @Binding var isNextToEnterCode : Bool
    @StateObject var viewModel = MyPageViewModel()
    
    @State var isShowingNotiView = false
    @State var isShowingUserInfoView = false
    @State var currency = CurrencyManager.shared.currentCurrency
    @State var isNextToMySubscription = false
    @State var isNextToUnSubscription = false
    @State var isNextToSubscription = false
    
    //@State var productPrice = IAPManager.shared.productList[0].price
    /*
    private var priceFormatter : NumberFormatter {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = IAPManager.shared.productList[0].priceLocale
        return priceFormatter
    }*/
    var body: some View {
        //@State var formattedPrice = priceFormatter.string(from: productPrice)
        ZStack {
            VStack(spacing:scaler.scaleHeight(26)) {
                HStack(spacing:scaler.scaleWidth(8)) {
                    Text("마이페이지")
                        //.padding(.horizontal, scaler.scaleWidth(4))
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(22)))
                        .foregroundColor(.greyScale1)
                    Spacer()
                    
                    NavigationLink(destination: NotificationView(showingTabbar: $showingTabbar), isActive: $isShowingNotiView) {
                        Image("icon_notification")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: scaler.scaleWidth(32),height: scaler.scaleWidth(32))
                   
                            .onTapGesture {
                                showingTabbar = false
                                isShowingNotiView = true
                            }
                    }
                    NavigationLink(destination: SettingView()) {
                        Image("icon_settings")
                            .resizable()
                            .frame(width: scaler.scaleWidth(32),height: scaler.scaleWidth(32))
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing:scaler.scaleHeight(16)) {
                        NavigationLink(destination: UserInformationView(), isActive: $isShowingUserInfoView) {
                            HStack(spacing:scaler.scaleWidth(16)) {
                                if let img = viewModel.userImg {
                                    if img == "user_default" {
                                        Image("user_profile_36")
                                            .resizable()
                                            .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36))
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                            .padding(.leading, scaler.scaleWidth(20))
                                            .padding(.vertical, scaler.scaleWidth(20))
                                        
                                    } else if img.hasPrefix("random"){
                                        let components = img.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                        let random = components.first!  // "random"
                                        let number = components.last!   // "5"
                                        Image("img_user_random_profile_0\(number)_36")
                                            .resizable()
                                            .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36))
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                            .padding(.leading, scaler.scaleWidth(20))
                                            .padding(.vertical, scaler.scaleWidth(20))
                                    }
                                    else {
                                        let url = URL(string : img)
                                        KFImage(url)
                                            .placeholder { //플레이스 홀더 설정
                                                Image("user_profile_36")
                                            }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                                            .onSuccess { success in //성공
                                                print("succes: \(success)")
                                            }
                                            .onFailure { error in //실패
                                                print("failure: \(error)")
                                            }
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                
                                            .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36))
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                            .padding(.leading, scaler.scaleWidth(20))
                                            .padding(.vertical, scaler.scaleWidth(20))
                                    }
                                } else {
                                    Image("user_profile_36")
                                        .resizable()
                                        .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36))
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: scaler.scaleWidth(1)))
                                        .padding(.leading, scaler.scaleWidth(20))
                                        .padding(.vertical, scaler.scaleWidth(20))
                                }

                                VStack(alignment: .leading, spacing:scaler.scaleHeight(8)){
                                    Text("\(viewModel.nickname)")
                                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale2)
                                    
                                    Text("\(viewModel.email)")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale3)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Image("forward_button")
                                    .resizable()
                                    .frame(width: scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                                    .padding(.trailing ,scaler.scaleWidth(16))
                            }
                            .background(Color.primary10)
                            //.frame(height: scaler.scaleHeight(76))
                            .cornerRadius(12)
                            .onTapGesture {
                                self.showingTabbar = false
                                self.isShowingUserInfoView = true
                            }
                        }
                        /*
                        if viewModel.subscribe {
                            Button {
                                self.isNextToMySubscription = true
                            } label: {
                                Text("구독 정보 보기")
                                    .frame(height: scaler.scaleHeight(46))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(13)))
                                    .foregroundColor(.greyScale12)
                                
                            }
                            .frame(height: scaler.scaleHeight(46))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.greyScale12)
                            .background(Color.greyScale2)
                            .cornerRadius(12)
                            
                        } else {*/
                            HStack(spacing:scaler.scaleWidth(12)){
                                VStack {
                                    HStack {
                                        Text("앱스토어에서\n별점을 남겨주세요")
                                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                        Spacer()
                                    }
                                    Spacer()
                                    Text("리뷰쓰기")
                                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                        .foregroundColor(.greyScale3)
                                }
                                .padding(scaler.scaleWidth(20))
                                .frame(maxWidth: .infinity)
                                .frame(height: scaler.scaleHeight(150))
                                .background(Color.greyScale12)
                                .cornerRadius(12)
                                //NavigationLink(destination: SubscriptionView(mypageViewModel:viewModel,isActive : $isNextToSubscription,showingTabbar: $showingTabbar), isActive: $isNextToSubscription) {
                                    VStack {
                                        /*
                                        HStack {
                                            VStack(alignment:.leading) {
                                                Text("월 \(formattedPrice!)으로")
                                                Text("더 많은 혜택을")
                                                Text("누려보세요!")
                                            }
                                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.white)
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                        Text("플랜보기")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.background3)*/
                                        
                                    }
                                    .padding(scaler.scaleWidth(20))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: scaler.scaleHeight(150))
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
                                    .onTapGesture {
                                        isNextToSubscription = true
                                        showingTabbar = false
                                    }
                                    
                                //}
                            }
                       // }
                    }
                    
                    VStack(spacing:scaler.scaleHeight(22)) {
                        HStack {
                            Text("내 가계부")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        .padding(.leading, scaler.scaleWidth(4))
                        
                        VStack(spacing:scaler.scaleHeight(16)) {
                            ForEach(viewModel.sortedBooks(), id:\.self) { book in
                                HStack {
                                    if let bookUrl = book.bookImg {
                                        //let url = encryptionManager.decrypt(bookUrl, using: encryptionManager.key!)
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
                                            .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36))
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(scaler.scaleWidth(20))
                                     
                                    } else {
                                        Image("book_profile_36")
                                            .resizable()
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .frame(width: scaler.scaleWidth(36), height: scaler.scaleWidth(36))
                                            .padding(scaler.scaleWidth(20))
                                    }

                                    VStack(alignment: .leading, spacing:scaler.scaleHeight(8)){
                                        Text("\(book.name)")
                                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                        Text("\(book.memberCount)명")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.greyScale6)
                                    }
                                    Spacer()
                                    if book.bookKey == Keychain.getKeychainValue(forKey: .bookKey) ?? "" {
                                        Image("icon_check_circle_activated")
                                            .padding(scaler.scaleWidth(20))
                                    } else {
                                        Image("icon_check_circle_disabled")
                                            .padding(scaler.scaleWidth(20))
                                            
                                    }
                                }
                                .background(Color.greyScale12)
                            .cornerRadius(12)
                                .onTapGesture {
                                    viewModel.changeBook(bookKey: book.bookKey) //bookStatus: book.bookStatus)
                                }
                            }
                            if viewModel.myBooks.count < 2 {
                                // MARK: Bottom Sheet Toggle
                                Button(action: {
                                    withAnimation{
                                        isShowingAccountBottomSheet = true
                                    }
                                }) {
                                    Image("icon_plus")
                                }
                                .padding(scaler.scaleWidth(20))
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.greyScale9, style:StrokeStyle(lineWidth: 1, dash: [6]))
                                )
                            }
                                
                        }
                    }.padding(.top, scaler.scaleHeight(32))
                    
                    VStack(spacing:scaler.scaleHeight(16)) {
                        HStack {
                            Text("고객지원")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                .foregroundColor(.greyScale1)
                            Spacer()
                        }
                        VStack(spacing:0) {
                            NavigationLink(destination : SendMailView(showingTabbar: $showingTabbar)) {
                                HStack {
                                    Text("문의하기")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale2)
                                    Spacer()
                                    Image("forward_button")
                                }
                                .frame(height: scaler.scaleHeight(56))
                            }
                            NavigationLink(destination : AnnouncementView(showingTabbar: $showingTabbar)) {
                                HStack {
                                    Text("공지사항")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                        .foregroundColor(.greyScale2)
                                    Spacer()
                                    Image("forward_button")
                                }
                                .frame(height: scaler.scaleHeight(56))
                            }
                            HStack {
                                Text("리뷰 작성하기")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                                Spacer()
                                Image("forward_button")
                            }
                            .frame(height: scaler.scaleHeight(56))
                            HStack {
                                Text("개인정보 처리방침")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                                Spacer()
                                Image("forward_button")
                            }
                            .frame(height: scaler.scaleHeight(56))
                            HStack {
                                Text("이용 약관")
                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                    .foregroundColor(.greyScale2)
                                Spacer()
                                Image("forward_button")
                            }
                            .frame(height: scaler.scaleHeight(56))
                        }
                    }
                    .padding(.top, scaler.scaleHeight(40))
                    .padding(.leading, scaler.scaleWidth(4))
                    /*
                    if viewModel.subscribe {
                        HStack {
                            VStack {
                                Text("구독 해지")
                                    .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                    .foregroundColor(.greyScale6)
                                Divider()
                                    .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                    .frame(width: 50,height: 1.0)
                                    .foregroundColor(.greyScale6)
                                
                            }
                            Spacer()
                        }
                        .padding(.leading, scaler.scaleWidth(4))
                        .padding(.top, scaler.scaleHeight(24))
                        .onTapGesture {
                            self.showingTabbar = false
                            self.isNextToUnSubscription = true
                        }
                    }*/
                    
                } // scroll view
                .padding(.horizontal,scaler.scaleWidth(20))
                
                
                NavigationLink(destination : SetBookNameView(createBookType: .add), isActive: $isNextToCreateBook) {
                    EmptyView()
                }
                NavigationLink(destination : EnterBookCodeView(), isActive: $isNextToEnterCode) {
                    EmptyView()
                }
                
                Spacer()
            } // vstack
            .padding(.top,scaler.scaleHeight(26))
            .onAppear{
                //if viewModel.subscribe {
                //    IAPManager.shared.verifyReceipt()
                //}
                viewModel.getMyPage()
                showingTabbar = true
            }
            //.fullScreenCover(isPresented: $isNextToMySubscription) {
            //    MySubscriptionView(showingTabbar: $showingTabbar, isShowing: $isNextToMySubscription, isShowingUnScribe: $isNextToUnSubscription)
            //}
            //.fullScreenCover(isPresented: $isNextToUnSubscription) {
            //    UnsubscribeView(showingTabbar: $showingTabbar, isShowing: $isNextToUnSubscription)
            //}

        } // ZStack
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showingTabbar: .constant(true), isShowingAccountBottomSheet: .constant(false), isNextToCreateBook: .constant(false), isNextToEnterCode: .constant(false))
    }
}
