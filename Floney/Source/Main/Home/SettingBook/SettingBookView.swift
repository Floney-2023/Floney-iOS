//
//  SettingBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI

struct SettingBookView: View {
    @Binding var isOnSettingBook : Bool
    @State var nickname = "team"
    @State var date = "2022.11.01 개설"
    var body: some View {
        ScrollView {
            VStack(spacing:30) {
                HStack {
                    Text("가계부 설정")
                        .padding(.horizontal, 4)
                        .font(.pretendardFont(.bold, size: 22))
                        .foregroundColor(.greyScale1)
                    Spacer()
                }
               // .padding(.bottom, 24)
                
                VStack(spacing:16) {
                    NavigationLink(destination: ModifyingBookView()) {
                        HStack {
                            Image("icon_profile_book")
                                .padding(20)
                            VStack(alignment: .leading, spacing:5){
                                Text("\(nickname)")
                                    .font(.pretendardFont(.bold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Text("\(date)")
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
                }
                
                VStack(spacing:0) {
                    HStack {
                        Text("사용자")
                            .font(.pretendardFont(.bold, size: 16))
                            .foregroundColor(.greyScale1)
                        Spacer()
                    }.padding(.bottom, 20)
                      //  .padding(.top, 32)
                    
                    VStack(spacing:16) {
                        HStack {
                            Image("icon_profile")
                                .padding(20)
                            VStack(alignment: .leading, spacing:5){
                                Text("고등어")
                                    .font(.pretendardFont(.bold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Text("방장")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                        }
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                    VStack(spacing:16) {
                        HStack {
                            Image("icon_profile")
                                .padding(20)
                            VStack(alignment: .leading, spacing:5){
                                Text("고등어")
                                    .font(.pretendardFont(.bold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Text("팀원")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                        }
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                    VStack(spacing:16) {
                        HStack {
                            Image("icon_profile")
                                .padding(20)
                            VStack(alignment: .leading, spacing:5){
                                Text("고등어")
                                    .font(.pretendardFont(.bold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Text("팀원")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                        }
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                    VStack(spacing:16) {
                        HStack {
                            Image("icon_profile")
                                .padding(20)
                            VStack(alignment: .leading, spacing:5){
                                Text("고등어")
                                    .font(.pretendardFont(.bold, size: 14))
                                    .foregroundColor(.greyScale2)
                                
                                Text("팀원")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale6)
                            }
                            Spacer()
                            
                        }
                        .background(Color.greyScale12)
                        .cornerRadius(12)
                    }
                }
                VStack(spacing:32) {
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
                    HStack {
                        Text("초기 자산 설정")
                        
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale2)
                        Spacer()
                    }
                    
                }
                HStack {
                    Text("화폐 설정")
                        .font(.pretendardFont(.bold,size: 16))
                        .foregroundColor(.greyScale1)
                    Spacer()
                    Image("forward_button")
                   
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
                NavigationLink(destination: FindPasswordView()){
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
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 0, trailing: 20))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton(), trailing: Image("icon_notification"))
        }
    }
}

struct SettingBookView_Previews: PreviewProvider {
    static var previews: some View {
        SettingBookView(isOnSettingBook: .constant(true))
    }
}
