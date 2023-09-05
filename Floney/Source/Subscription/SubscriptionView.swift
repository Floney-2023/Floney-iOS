//
//  SubscriptionView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/29.
//

import SwiftUI

struct SubscriptionView: View {
    @ObservedObject var notificationManager = NotificationManager()
    @State var productID = IAPProducts.FloneyPlusMonthly.rawValue
    @State var isSelected = 1
    @State var currency = CurrencyManager.shared.currentCurrency
    let qaList: [QA] = [
        QA(id : 0,question: "방장이 구독 중인 경우, 같은 방에 있는 팀원들\n도 멤버를 추가할 수 있나요?", answer: "네.\n팀원들이 자유롭게 초대하여 추가할 수 있습니다."),
        QA(id : 1,question: "방장이 구독하지 않고, 같은 방에 있는 팀원이 \n구독중인 경우 멤버를 추가할 수 있나요?", answer: "아니요.\n방장이 구독을 해야 멤버 추가를 할 수 있습니다."),
        QA(id: 2,question: "가계부를 초대받아 사용하고 있습니다.\n가계부를 1개 더 사용하고 싶으면 어떻게 하나요?", answer: "가계부 추가를 원하시는 경우 플로니 플러스+\n플랜을 구독하실 수 있습니다."),
        QA(id: 3,question: "가계부를 초대받아 사용하고 있습니다.\n광고 제거를 하고 싶어요.", answer: "광고 제거를 원하시는 경우 플로니 플러스+ 플\n랜을 구독하거나, 30초 광고보기를 통해 없앨 수 있습니다.")
    ]
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    Image("illust_floney_plus")
                    VStack(spacing:10) {
                        Text("floney Plus+ 구독으로")
                        Text("편리하고 다양한 기능을 즐겨보세요")
                    }
                    .font(.pretendardFont(.bold, size: 22))
                    .foregroundColor(.greyScale2)
                    .padding(.bottom,20)
                    VStack(spacing:3) {
                        Text("광고를 제거하고 초대할 수 있는 인원이 늘어나요!")
                        Text("가계부를 하나 더 쓸 수 있는 혜택을 누려보세요.")
                    }
                    .font(.pretendardFont(.medium, size: 14))
                    .foregroundColor(.greyScale6)
                    .padding(.bottom,54)
                    VStack {
                        HStack{
                            Text("")
                                .frame(maxWidth: .infinity)
                            Text("floney Basic")
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.greyScale8)
                            Text("floney Plus+")
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(.greyScale2)
                        }
                        
                        HStack(spacing:18) {
                            VStack(alignment: .leading, spacing:53) {
                                Text("모든 가계부 기능")
                                Text("광고 제거")
                                Text("사용 가능 인원")
                                Text("가계부 수")
                                Text("엑셀 내보내기")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,20)
                            .font(.pretendardFont(.semiBold, size: 12))
                            .foregroundColor(.greyScale3)
                            VStack(spacing:46) {
                                Image("icon_check_circle_disabled")
                                Image("icon_check_circle_disabled")
                                Text("2명")
                                Text("1개")
                                Image("icon_check_circle_disabled")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,20)
                            .font(.pretendardFont(.semiBold, size: 14))
                            .foregroundColor(.greyScale7)
                            .background(Color.background3)
                            .cornerRadius(12)
                            VStack(spacing:46) {
                                Image("icon_check_circle_activated")
                                Image("icon_check_circle_activated")
                                Text("4명")
                                Text("2개")
                                Image("icon_check_circle_activated")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,20)
                            .font(.pretendardFont(.semiBold, size: 14))
                            .foregroundColor(.primary1)
                            .background(Color.primary10)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color.primary5, lineWidth: 1)
                            )
                            
                            
                        }
                    }.padding(.horizontal,26)
                        .padding(.bottom, 56)
                    VStack(spacing: 11) {
                        VStack(spacing:5) {
                            Text("연간 구독으로")
                            Text("15%를 할인 받을 수 있어요!")
                        }
                        .padding(.bottom, 13)
                        .font(.pretendardFont(.bold, size: 18))
                        .foregroundColor(.white)
                        Button {
                            isSelected = 1
                            productID = IAPProducts.FloneyPlusMonthly.rawValue
                        } label: {
                            HStack{
                                Text("월간 구독")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale3)
                                Spacer()
                                Text("월")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale5)
                                Text("3,800\(currency)")
                                    .font(.pretendardFont(.bold, size: 20))
                                    .foregroundColor(.greyScale3)
                                Image(isSelected == 1 ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                            }
                            .padding(20)
                            .frame(height: 60)
                            .background(isSelected == 1 ? Color.white : Color.background3)
                            
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if isSelected == 1 {
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.5)
                                            .stroke(Color.primary5, lineWidth: 1)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                        }
                        Button {
                            isSelected = 2
                            productID = IAPProducts.FloneyPlusYearly.rawValue
                        } label: {
                            HStack{
                                Text("연간 구독")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale3)
                                Spacer()
                                Text("연")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale5)
                                Text("38,000\(currency)")
                                    .font(.pretendardFont(.bold, size: 20))
                                    .foregroundColor(.greyScale3)
                                Image(isSelected == 2 ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                            }
                            .padding(20)
                            .frame(height: 60)
                            .background(isSelected == 2 ? Color.white : Color.background3)
                            
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if isSelected == 2 {
                                        RoundedRectangle(cornerRadius: 12)
                                            .inset(by: 0.5)
                                            .stroke(Color.primary5, lineWidth: 1)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            )
                            
                        }
 
                    }
                    .padding(.vertical,32)
                    .padding(.horizontal,20)
                    .padding(.bottom, 19)
                    .frame(maxWidth: .infinity)
                    .background(Color.primary4)
                    
                    Text("자주 묻는 질문")
                        .padding(.top, 60)
                        .padding(.bottom, 24)
                        .font(.pretendardFont(.bold, size: 16))
                        .foregroundColor(.greyScale2)
                    VStack(spacing:16) {
                        ForEach(qaList) { qa in
                            VStack(spacing:12) {
                                HStack{
                                    Text("Q. \(qa.question)")
                                        .font(.pretendardFont(.medium, size: 14))
                                        .foregroundColor(.greyScale4)
                                    Spacer()
                                }
                                HStack {
                                    Text("A. \(qa.answer)")
                                        .font(.pretendardFont(.semiBold, size: 14))
                                        .foregroundColor(.greyScale3)
                                    Spacer()
                                }
                                
                            }
                            .padding(20)
                            .background(Color.background3)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                    
                }
                
            }
            VStack {
                Spacer()
                Button {
                    // 구매하지 않았으면 구매
                    if !IAPManager.shared.isProductPurchased(productID) {
                        IAPManager.shared.buyProduct(productID)
                    }
                } label: {
                    Text("floney Plus+ 구독하기")
                        .font(.pretendardFont(.bold, size: 14))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(Color.primary1)
                .cornerRadius(12)
            }
            .padding(20)

        }// ZStack
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonBlack())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("구독")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
            }
        }
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
