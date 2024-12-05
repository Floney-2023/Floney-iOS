//
//  SubscriptionView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/29.
//

import SwiftUI

struct SubscriptionView: View {
    let scaler = Scaler.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var notificationManager = NotificationManager()
    @ObservedObject var mypageViewModel : MyPageViewModel
    @ObservedObject var viewModel = SubscriptionViewModel()
    @ObservedObject var iapManager : IAPManager
    @Binding var isActive : Bool
    @Binding var showingTabbar : Bool
    @State var productID = IAPProducts.FloneyPlusMonthly.rawValue
    @State var isSelected = 1
    @State var currency = CurrencyManager.shared.currentCurrency
    
    let qaList: [QA] = [
        QA(id : 0,question: "방장이 구독 중인 경우, 같은 방에 있는 팀원들도 floney Plus+ 기능을 이용할 수 있나요?", answer: "네.\n방장이 구독 중인 경우 해당 가계부의 모든 팀원이 floney Plus+ 기능을 이용할 수 있습니다. 다만 광고 제거가 필요한 경우는 개별 구독이 필요합니다."),
        QA(id : 1,question: "같은 방에 있는 팀원이 구독중인 경우 floney Plus+ 기능을 이용할 수 있나요?", answer: "아니오.\n가계부에 팀원으로 들어간 경우에는 해당 가계부의 방장이 구독 중인 경우에만 구독 혜택을 사용할 수 있습니다. 만약 구독 혜택을 이용하고 싶으신 경우 본인이 직접 가계부를 생성하거나 기존 방장이 탈퇴 시, 구독 중인 팀원들 중 랜덤으로 자동 위임이 됩니다.\n(단, 가계부를 나간 사용자의 기존 내역은 삭제됩니다.)"),
        QA(id: 2,question: "가계부를 초대받아 사용하고 있습니다.\n광고 제거를 하고 싶어요.", answer: "광고 제거를 원하시는 경우 floney Plus+ 플랜을 구독하거나, 30초 광고보기를 통해 없앨 수 있습니다."),
        QA(id: 3,question: "방장을 포함하여 여러명이 구독중인 경우, 특정한 사람에게 방장을 위임할 수 있나요?", answer: "아니오.\n현재 방장 변경은 방장의 가계부 나가기로 인한 자동 위임만 가능합니다."),
        QA(id: 4,question: "Q. 구독을 해지하게 되면 기존 가계부들은 어떻게 되나요?", answer: "해당 가계부에 구독 혜택이 적용되어 있는 경우에는 마이페이지, 가계부 설정 페이지만 접근이 가능합니다. \n다시 사용을 원한다면 다시 floney Plus+를 구독하시거나 구독 혜택에 해당되는 서비스를 수정 및 삭제 하시면 floney Basic으로 다시 사용이 가능합니다."),
    ]
    var body: some View {
        //@State var formattedPrice = priceFormatter.string(from: productPrice)
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    Image("illust_floney_plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:scaler.scaleWidth(360), height: scaler.scaleHeight(264))
                     
                    VStack(spacing:scaler.scaleHeight(10)) {
                        Text("floney Plus+ 구독으로")
                        Text("편리하고 다양한 기능을 즐겨보세요")
                    }
                    .font(.pretendardFont(.bold, size:scaler.scaleWidth(22)))
                    .foregroundColor(.greyScale2)
                    .padding(.bottom,20)
                    VStack(spacing:scaler.scaleHeight(3)) {
                        Text("광고를 제거하고 초대할 수 있는 인원이 늘어나요!")
                        Text("플로니의 다양한 혜택을 누려보세요.")
                    }
                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                    .foregroundColor(.greyScale6)
                    .padding(.bottom,scaler.scaleHeight(54))
                    VStack {
                        HStack{
                            Text("")
                                .frame(maxWidth: .infinity)
                            Text("Floney Basic")
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale8)
                            Text("Floney Plus+")
                                .frame(maxWidth: .infinity)
                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                        }
                        
                        HStack(spacing:scaler.scaleWidth(18)) {
                            VStack(alignment: .leading, spacing:scaler.scaleHeight(53)) {
                                Text("기본 가계부 기능")
                                Text("광고 제거")
                                Text("사용 가능 인원")
                                Text("가계부 수")
                                Text("즐겨찾기 개수")
                                Text("분석 상세 내역")
                                Text("내역 메모/사진")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,scaler.scaleHeight(20))
                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale3)
                            
                            VStack(spacing:0) {
                                Image("icon_check_circle_disabled")
                                    .padding(.bottom,scaler.scaleHeight(41))
                                Image("icon_check_circle_disabled")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Text("4명")
                                    .padding(.bottom,scaler.scaleHeight(51))
                                Text("2개")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Text("각 5개")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Image("icon_check_circle_disabled")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Image("icon_check_circle_disabled")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,scaler.scaleHeight(20))
                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale7)
                            .background(Color.background3)
                            .cornerRadius(12)
                            
                            VStack(spacing:0) {
                                Image("icon_check_circle_activated")
                                    .padding(.bottom,scaler.scaleHeight(41))
                                Image("icon_check_circle_activated")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Text("10명")
                                    .padding(.bottom,scaler.scaleHeight(51))
                                Text("4개")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Text("무제한")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Image("icon_check_circle_activated")
                                    .padding(.bottom,scaler.scaleHeight(46))
                                Image("icon_check_circle_activated")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,scaler.scaleHeight(20))
                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                            .foregroundColor(.primary1)
                            .background(Color.primary10)
                            .cornerRadius(12)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .inset(by: 0.5)
                                    .stroke(Color.primary5, lineWidth: 1)
                            )
                            
                            
                        }
                    }.padding(.horizontal,scaler.scaleWidth(26))
                    .padding(.bottom, scaler.scaleHeight(16))
                    HStack {
                        Spacer()
                        Text(iapManager.products.isEmpty ? "" : "\(iapManager.products[0].price)")
                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(18)))
                            .foregroundColor(.greyScale1)
                        + Text(" / 월")
                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                            .foregroundColor(.greyScale3)
                    }.padding(.trailing, scaler.scaleWidth(26))
                    .padding(.bottom, scaler.scaleHeight(52))
         
                    VStack {
                        Text("자주 묻는 질문")
                            .padding(.top, scaler.scaleHeight(34))
                            .padding(.bottom, scaler.scaleHeight(24))
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                            .foregroundColor(.white)
                        VStack(spacing:scaler.scaleHeight(16)) {
                            ForEach(qaList) { qa in
                                VStack(spacing:scaler.scaleHeight(12)) {
                                    HStack{
                                        Text("Q. \(qa.question)")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale4)
                                            .lineSpacing(5)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        Spacer()
                                    }
                                    .frame(width:scaler.scaleWidth(272))
                                    HStack {
                                        Text("A. \(qa.answer)")
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale3)
                                            .lineSpacing(5)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                        Spacer()
                                    }
                                    .frame(width:scaler.scaleWidth(272))
                                    
                                }
                                .padding(scaler.scaleWidth(20))
                                .background(Color.background3)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, scaler.scaleWidth(24))
                        .padding(.bottom, scaler.scaleHeight(100))
                    }
                    .background(Color.primary4)
                    
                    VStack(spacing:5) {
                        HStack {
                            Text("- 플랜은 구독시 혜택이 즉시 적용됩니다.\n- 현재 이용 중인 플랜이 종료되기 24시간 전이라면 언제든지 해약이 가능합니다.\n- 현재 이용 중인 플랜이 종료되기 24시간 전까지 해약하지 않으면 자동으로 구독이 갱신되며 이에 따른 요금이 청구됩니다.")
                                .font(.pretendardFont(.regular, size:scaler.scaleWidth(12)))
                                .foregroundColor(.greyScale2)
                                .lineSpacing(5)
                                .frame(width:scaler.scaleWidth(312), alignment: .topLeading)
                            Spacer()
                        }
                        HStack{
                            Text("- 앱을 삭제하는 것만으로는 인앱결제 구독 플랜이 해약되지 않으니 주의해 주시기 바랍니다.  ") + Text("구매내역 복원하기")
                                    .underline()

                        }
                        .lineSpacing(5)
                        .font(.pretendardFont(.regular, size:scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale2)
                        .frame(width:scaler.scaleWidth(312), alignment: .topLeading)
                        HStack{
                            Text("- 구독 해지 및 환불 관련은 서비스 이용 약관을 확인해 주시기 바랍니다.  ") + Text("서비스 이용 약관")
                                .underline()
                        }
                        .lineSpacing(5)
                        .font(.pretendardFont(.regular, size:scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale2)
                        .frame(width:scaler.scaleWidth(312), alignment: .topLeading)
                    }
                    .padding(.bottom, scaler.scaleHeight(120))
                    .padding(.top, scaler.scaleHeight(24))
                    .padding(.horizontal, scaler.scaleWidth(24))
                    .frame(maxWidth:.infinity)
                }
                
            }
            VStack {
                Spacer()
                VStack {
                    Button {
                        Task {
                            await iapManager.buyProduct(iapManager.products[0])
                        }
                    } label: {
                        Text("floney Plus+ 구독하기")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(scaler.scaleWidth(16))
                    .background(Color.primary1)
                    .cornerRadius(12)
                    
                }
                .padding(.horizontal,scaler.scaleWidth(20))
                .padding(.top, scaler.scaleHeight(16))
                .padding(.bottom, scaler.scaleHeight(22))
                .frame(width: scaler.scaleWidth(360),height:  scaler.scaleHeight(84))
                .background(Color.white)
  
            }
            .edgesIgnoringSafeArea(.bottom)

        }// ZStack
        .customNavigationBar(
            leftView: { BackButtonBlack() } ,
            centerView: { Text("구독 플랜")
                    .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)
            })
        .onChange(of: notificationManager.dismissStatus) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            Task {
                await iapManager.loadProducts()
            }
            Task {
                let id = await iapManager.getTransactionInfo()
                print("구독 페이지에서 id = \(id)")
                viewModel.postTransactionId(id: id)
            }

        }
        .edgesIgnoringSafeArea(.bottom)

    }
   
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView(mypageViewModel : MyPageViewModel(),iapManager: IAPManager(), isActive: .constant(true),showingTabbar: .constant(false))
    }
}
