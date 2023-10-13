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
    
    @State var productPrice = IAPManager.shared.productList[0].price

    private var priceFormatter : NumberFormatter {
        let priceFormatter = NumberFormatter()
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = IAPManager.shared.productList[0].priceLocale
        return priceFormatter
    }
    var body: some View {
        @State var formattedPrice = priceFormatter.string(from: productPrice)
        ZStack {
            VStack(spacing:26) {
                HStack {
                    Text("마이페이지")
                        .padding(.horizontal, 4)
                        .font(.pretendardFont(.bold, size: 22))
                        .foregroundColor(.greyScale1)
                    
                    Spacer()
                    NavigationLink(destination: NotificationView(viewModel: viewModel.notiviewModel,showingTabbar: $showingTabbar), isActive: $isShowingNotiView) {
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
                        NavigationLink(destination: UserInformationView(), isActive: $isShowingUserInfoView) {
                            HStack {
                                if let img = viewModel.userImg {
                                    if img == "user_default" {
                                        Image("user_profile_36")
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
                                        
                                    } else if img.hasPrefix("random"){
                                        let components = img.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                        let random = components.first!  // "random"
                                        let number = components.last!   // "5"
                                        Image("img_user_random_profile_0\(number)_36")
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
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
                                            .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                            .frame(width: 36, height: 36) //resize
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            .padding(20)
                                    }
                                } else {
                                    Image("user_profile_36")
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(20)
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
                            .onTapGesture {
                                self.showingTabbar = false
                                self.isShowingUserInfoView = true
                            }
                        }
                        
                        if viewModel.subscribe {
                            Button {
                                self.isNextToMySubscription = true
                            } label: {
                                Text("구독 내역 보기")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .font(.pretendardFont(.semiBold, size: 13))
                                    .foregroundColor(.greyScale12)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.greyScale12)
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
                                NavigationLink(destination: SubscriptionView(mypageViewModel:viewModel,isActive : $isNextToSubscription,showingTabbar: $showingTabbar), isActive: $isNextToSubscription) {
                                    VStack {
                                        HStack {
                                            VStack(alignment:.leading) {
                                                Text("월 \(formattedPrice!)으로")
                                                Text("더 많은 혜택을")
                                                Text("누려보세요!")
                                            }
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
                                    .onTapGesture {
                                        isNextToSubscription = true
                                        showingTabbar = false
                                    }
                                    
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
                            ForEach(viewModel.sortedBooks(), id:\.self) { book in
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
                                    if book.bookKey == Keychain.getKeychainValue(forKey: .bookKey) ?? "" {
                                        Image("icon_check_circle_activated")
                                            .padding(20)
                                    } else {
                                        Image("icon_check_circle_disabled")
                                            .padding(20)
                                            
                                    }
                                }
                                .background(Color.greyScale12)
                                .cornerRadius(12)
                                .onTapGesture {
                                    viewModel.changeBook(bookKey: book.bookKey, bookStatus: book.bookStatus)
                                }
                            }
                            
                            
                            // MARK: Bottom Sheet Toggle
                            Button(action: {
                                withAnimation{
                                    isShowingAccountBottomSheet = true
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
                    }.padding(.top, 32)
                    VStack(spacing:42) {
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
                    }.padding(.top, 40)
                    
                    if viewModel.subscribe {
                        
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
                        .padding(.top, 44)
                        .onTapGesture {
                            self.showingTabbar = false
                            self.isNextToUnSubscription = true
                        }
                    }
                    
                } // scroll view
                .padding(.horizontal,20)
                
                NavigationLink(destination : SetBookNameView(createBookType: .add), isActive: $isNextToCreateBook) {
                    EmptyView()
                }
                NavigationLink(destination : EnterBookCodeView(), isActive: $isNextToEnterCode) {
                    EmptyView()
                }
            } // vstack
            .fullScreenCover(isPresented: $isNextToMySubscription) {
                MySubscriptionView(showingTabbar: $showingTabbar, isShowing: $isNextToMySubscription, isShowingUnScribe: $isNextToUnSubscription)
            }
            .fullScreenCover(isPresented: $isNextToUnSubscription) {
                UnsubscribeView(showingTabbar: $showingTabbar, isShowing: $isNextToUnSubscription)
            }
            .onAppear{
                if viewModel.subscribe {
                    IAPManager.shared.verifyReceipt()
                }
                viewModel.getMyPage()
                showingTabbar = true
            }
            
            
        } // ZStack
        .padding(.top, 26)
        
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showingTabbar: .constant(true), isShowingAccountBottomSheet: .constant(false), isNextToCreateBook: .constant(false), isNextToEnterCode: .constant(false))
    }
}
