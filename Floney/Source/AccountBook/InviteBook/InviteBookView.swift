//
//  InviteBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/04.
//

import SwiftUI
import Kingfisher

struct InviteBookView: View {
    let scaler = Scaler.shared
    var applinkManager = AppLinkManager.shared
    @StateObject var viewModel = CreateBookViewModel()
    @State var showAlert = false
    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                HStack {
                    Text("초대받은 가계부에\n입장하기")
                        .lineSpacing(6)
                        .font(.pretendardFont(.bold, size:scaler.scaleWidth(24)))
                        .foregroundColor(.greyScale1)
                    Spacer()
                }
                .padding(.leading, scaler.scaleWidth(4))
                .padding(.bottom, scaler.scaleHeight(48))
    
                if let bookUrl = viewModel.bookInfo.bookImg {
                    let url = URL(string : bookUrl)
                    KFImage(url)
                        .placeholder {
                            Image("book_profile_110")
                        }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                        .onSuccess { success in //성공
                            print("success: \(success)")
                        }
                        .onFailure { error in //실패
                            print("failure: \(error)")
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: scaler.scaleWidth(110), height: scaler.scaleWidth(110))
                        .clipShape(Circle())
                        .padding(.bottom, scaler.scaleHeight(12))
                    
                } else {
                    Image("book_profile_110")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: scaler.scaleWidth(110), height: scaler.scaleWidth(110))
                        .clipShape(Circle())
                        .padding(.bottom, scaler.scaleHeight(12))
                }
                
                Text("\(viewModel.bookName)")
                    .font(.pretendardFont(.bold, size: scaler.scaleWidth(18)))
                    .foregroundColor(.greyScale2)
                    .padding(.bottom, scaler.scaleHeight(10))
                
                Text("\(viewModel.startDay) 개설 ‧ \(viewModel.memberCount)명")
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                    .foregroundColor(.greyScale3)
                    .padding(.bottom, scaler.scaleHeight(32))
                
                VStack(spacing:scaler.scaleHeight(8)) {
                    Text("초대코드")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale8)
                    HStack {
                        ZStack {
                            Text("\(applinkManager.inviteCode!)")
                                .padding(scaler.scaleHeight(16))
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                                .background(Color.greyScale12)
                                .cornerRadius(12)
                            HStack {
                                Spacer()
                                Image("icon_copy")
                                    .padding(.trailing, scaler.scaleWidth(16))
                            }
                        }
                    }
                    .frame(width: scaler.scaleWidth(320))
                    
                }
                .padding(.horizontal, scaler.scaleWidth(4))
                .onTapGesture {
                    // 클립보드에 값 복사하기
                    UIPasteboard.general.string = applinkManager.inviteCode
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("초대 코드 복사"), message: Text("초대 코드가 복사되었습니다."), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
                
                VStack(spacing:scaler.scaleHeight(18)) {
                    Button {
                        LoadingManager.shared.update(showLoading: true, loadingType: .floneyLoading)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                            viewModel.inviteBookCode()
                        }
                    } label: {
                        Text("입장하기")
                            .padding(scaler.scaleHeight(16))
                            .font(.pretendardFont(.bold,size: scaler.scaleWidth(14)))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.primary1)
                            .cornerRadius(12)
                    }
                    NavigationLink(destination: EnterBookCodeView()) {
                        VStack(spacing:0) {
                            Text("코드 입력하기")
                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale6)
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: scaler.scaleWidth(66), height: scaler.scaleWidth(0.7))
                              .background(Color.greyScale6)
                        }
                    }
                }
                
            }
            .onAppear {
                viewModel.bookInfoByCode()
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(32), leading: scaler.scaleWidth(20), bottom: scaler.scaleHeight(30), trailing: scaler.scaleWidth(20)))
            .customNavigationBar(
                rightView: {
                    Image("icon_close")
                        .padding(.top, scaler.scaleHeight(22))
                        .onTapGesture {
                            AppLinkManager.shared.inviteStatus = false
                            AppLinkManager.shared.hasDeepLink = false
                            BookExistenceViewModel.shared.getBookExistence()
                        }
                }
            )
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationViewStyle(.stack)
    }
}

struct InviteBookView_Previews: PreviewProvider {
    static var previews: some View {
        InviteBookView()
    }
}
