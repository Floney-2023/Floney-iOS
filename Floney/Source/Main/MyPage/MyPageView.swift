//
//  MyPageView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct MyPageView: View {
    @State var nickname = "user"
    @State var email = "user@gmail.com"
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing:32) {
                    HStack {
                        Text("마이페이지")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                        Spacer()
                        Image("icon_notification")
                        Image("icon_settings")
                        
                    }
                    
                    VStack(spacing:16) {
                        HStack {
                            Image("icon_profile")
                                .padding(20)
                            VStack(alignment: .leading, spacing:5){
                                Text("\(nickname)")
                                    .font(.pretendardFont(.bold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Text("\(email)")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale3)
                                
                                
                            }
                            Spacer()
                            Image("forward_button")
                                .padding(20)
                        }
                        .background(Color.primary10)
                        .cornerRadius(12)
                        
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
                            HStack {
                                Image("icon_profile")
                                    .padding(20)
                                VStack(alignment: .leading, spacing:5){
                                    Text("\(nickname)")
                                        .font(.pretendardFont(.bold, size: 14))
                                        .foregroundColor(.greyScale2)
                                    
                                    Text("1명")
                                        .font(.pretendardFont(.medium, size: 12))
                                        .foregroundColor(.greyScale6)
                                    
                                    
                                }
                                Spacer()
                                Image("icon_check_circle")
                                    .padding(20)
                            }
                            .background(Color.greyScale12)
                            .cornerRadius(12)
                            
                            Button(action: {
                                print("Hello button tapped!")
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
                            Text("서비스")
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
                .padding(24)
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
