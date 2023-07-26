//
//  MyPageView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MyPageView: View {
    @Binding var showingTabbar : Bool
    var encryptionManager = CryptManager()
    var profileManager = ProfileManager.shared
    //@State var nickname = "플로니"
    //@State var email = "floney.dev@gmail.com"
    @State var isShowingBottomSheet = false
    @StateObject var viewModel = MyPageViewModel()
    @State var isShowingNotiView = false
    
    var body: some View {
      //  NavigationView {
        ZStack {
            
                VStack(spacing:32) {
                    HStack {
                        Text("마이페이지")
                            .padding(.horizontal, 4)
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                            
                        Spacer()
                        NavigationLink(destination: NotificationView(showingTabbar: $showingTabbar), isActive: $isShowingNotiView) {
                            Image("icon_notification")
                                .onTapGesture {
                                    isShowingNotiView = true
                                }
                        }
                        Image("icon_settings")
                        
                    }.padding(.horizontal, 20)
                    ScrollView(showsIndicators: false) {
                    
                    VStack(spacing:16) {
                        NavigationLink(destination: UserInformationView(viewModel: viewModel)) {
                            HStack {
                                Image("user_profile_36")
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                    .padding(20)

                                /*
                                if viewModel.userImg == "user_default" {
                                    Image("user_profile_36")
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(20)
                                } else {
                                    let url = encryptionManager.decrypt(viewModel.userImg, using: encryptionManager.key!)
                                    URLImage(url: URL(string: url!)!)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 34, height: 34)
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                }*/
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
                        
                        
                        Button("구독 내역 보기") {
                        }
                        .padding()
                        .font(.pretendardFont(.semiBold, size: 13))
                        .foregroundColor(.greyScale12)
                        .frame(maxWidth: .infinity)
                        .background(Color.greyScale2)
                        .cornerRadius(12)
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
                                    /*
                                    Image("book_profile_36")
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        .padding(20)*/
                                    
                                    if let bookUrl = book.bookImg {
                                        let url = encryptionManager.decrypt(bookUrl, using: encryptionManager.key!)
                                        URLImage(url: URL(string: url!)!)
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                            .frame(width: 36, height: 36)
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
                .padding(20)
                .onAppear{
                    viewModel.getMyPage()
                    showingTabbar = true
                }
                
            }
            // }
            
            // MARK: Bottom Sheet
            BottomSheet(isShowing: $isShowingBottomSheet, content: BottomSheetType.accountBook.view())
        }
    }
}


struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView(showingTabbar: .constant(true))
    }
}
