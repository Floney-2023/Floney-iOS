//
//  InviteBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/04.
//

import SwiftUI

struct InviteBookView: View {
    var applinkManager = AppLinkManager.shared
    @StateObject var viewModel = CreateBookViewModel()
    @State var showAlert = false
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading,spacing: 10) {
                        Text("초대받은 가계부에")
                        Text("입장하기")
                    }
                    .font(.pretendardFont(.bold, size: 24))
                    .foregroundColor(.greyScale1)
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.leading, 24)
                .padding(.bottom,48)
                
                Image("book_profile_110")
                Text("\(viewModel.bookName)")
                    .font(.pretendardFont(.bold, size: 18))
                    .foregroundColor(.greyScale2)
                    .padding(.bottom,1)
                Text("\(viewModel.startDay) 개설 ‧ \(viewModel.memberCount)명")
                    .font(.pretendardFont(.medium, size: 14))
                    .foregroundColor(.greyScale3)
                    .padding(.bottom, 32)
                
                VStack(spacing:8) {
                    Text("초대코드")
                        .font(.pretendardFont(.medium, size: 12))
                        .foregroundColor(.greyScale8)
                    Text("\(applinkManager.inviteCode!)")
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.greyScale2)
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                }
                .padding(.horizontal,24)
                .onTapGesture {
                    // 클립보드에 값 복사하기
                    UIPasteboard.general.string = applinkManager.inviteCode
                    showAlert = true
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("초대 코드 복사"), message: Text("초대 코드가 복사되었습니다."), dismissButton: .default(Text("OK")))
                }
                Spacer()
                VStack(spacing:18) {
                    Button {
                        viewModel.inviteBookCode()
                    } label: {
                        Text("입장하기")
                            .padding(16)
                            .font(.pretendardFont(.bold,size: 14))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.primary1)
                            .cornerRadius(12)
                    }
                    NavigationLink(destination: EnterBookCodeView()) {
                        VStack {
                            Text("코드 입력하기")
                                .font(.pretendardFont(.regular, size: 12))
                                .foregroundColor(.greyScale6)
                            Divider()
                                .frame(width: 70,height: 1.0)
                                .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 0))
                                .foregroundColor(.greyScale6)
                        }
                    }
                }
                .padding(.horizontal,20)
                
            }
            .onAppear {
                viewModel.bookInfoByCode()
            }
            .customNavigationBar(
                rightView: {
                    Image("icon_close")
                        .onTapGesture {
                            AppLinkManager.shared.inviteStatus = false
                            AppLinkManager.shared.hasDeepLink = false

                            BookExistenceViewModel.shared.getBookExistence()
                        }
                }
            )
        }
    }
}

struct InviteBookView_Previews: PreviewProvider {
    static var previews: some View {
        InviteBookView()
    }
}
