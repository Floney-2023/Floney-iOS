//
//  CompleteCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI
import Kingfisher

struct CompleteCalcView: View {
    let scaler = Scaler.shared
    @State var currency = CurrencyManager.shared.currentCurrency
    @StateObject var applinkManager = AppLinkManager.shared
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
    @State var totalMoney = 200000
    @Binding var pageCount : Int
    @State var onShareSheet = false
    var pageCountAll = 4
    @ObservedObject var viewModel : CalculateViewModel
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("icon_close")
                    .padding(.trailing,scaler.scaleWidth(20))
                    .padding(.top,scaler.scaleHeight(22))
                    .onTapGesture {
                        self.isShowingTabbar = true
                        self.isShowingCalc = false
                    }
            }
            
            VStack(alignment: .leading,spacing:scaler.scaleHeight(24)) {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(8)) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        Text("정산이")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                            .foregroundColor(.greyScale1)
                            .padding(.top, scaler.scaleHeight(11))
                        Text("완료되었어요!")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                            .foregroundColor(.greyScale1)
                        
                        Text("소수점은 반올림되어 계산됩니다.")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale8)
                    }
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width:scaler.scaleWidth(74), height: scaler.scaleWidth(74))
                        .background(
                            Image("calculate_complete")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:scaler.scaleWidth(74), height: scaler.scaleWidth(74))
                      
                        )
                }
                .padding(.horizontal, scaler.scaleWidth(24))
                .padding(.bottom, scaler.scaleHeight(8))
                VStack(spacing:scaler.scaleHeight(20)) {
                    HStack {
                        Text("총 지출")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(16)))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Text("\(viewModel.totalOutcome.formattedString)\(currency)")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                            .foregroundColor(.greyScale2)
                    }.padding(.horizontal, scaler.scaleWidth(4))
                    
                    
                    GeometryReader { geometry in
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                        }
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .foregroundColor(.greyScale9)
                    }
                    .frame(height: 1)
                }.padding(.horizontal, scaler.scaleWidth(24))
                
                VStack(spacing: scaler.scaleHeight(20)) {
                    ForEach(viewModel.details, id:\.self){ detail in
                        HStack {
                            Text("\(detail.userNickname)")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale6)
                            Spacer()
                            Text("\((detail.money+viewModel.outcomePerUser).formattedString)\(currency)")
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                .foregroundColor(.greyScale2)
                        }
                    }
                    
                }
                .padding(.horizontal, scaler.scaleWidth(28))
                
                VStack(spacing:scaler.scaleHeight(20)) {
                    GeometryReader { geometry in
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                        }
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .foregroundColor(.greyScale9)
                    }
                    .frame(height: 1)
                    
                    HStack {
                        Text("정산 금액")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(16)))
                            .foregroundColor(.greyScale2)
                        Spacer()
                        Text("1인")
                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(10)))
                            .foregroundColor(.greyScale6)
                        Text("\(viewModel.outcomePerUser.formattedString)\(currency)")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                            .foregroundColor(.primary2)
                    }
                    .padding(.horizontal, scaler.scaleWidth(4))
                }
                .padding(.horizontal, scaler.scaleWidth(24))
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: scaler.scaleWidth(360), height: scaler.scaleHeight(4))
                    .background(Color.background2)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing:scaler.scaleHeight(32)) {
                        ForEach(viewModel.details, id: \.self) { detail in
  
                                HStack(spacing:scaler.scaleWidth(11)) {
                                    if let profileImg = detail.userProfileImg {
                                        if profileImg == "user_default" {
                                            Image("user_profile_32")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            
                                        } else if profileImg.hasPrefix("random"){
                                            
                                            let components = profileImg.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                            let random = components.first!  // "random"
                                            let number = components.last!   // "5"
                                            Image("img_user_random_profile_0\(number)_32")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                        }
                                        else {
                                            let url = URL(string : profileImg)
                                            KFImage(url)
                                                .placeholder { //플레이스 홀더 설정
                                                    Image("user_profile_32")
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
                                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                            
                                        }
                                    } else {
                                        Image("user_profile_32")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                                            .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32)) //resize
                                            .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                                    }
                                    
                                    
                                    VStack(alignment:.leading) {
                                        Text("\(detail.userNickname)")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                            .foregroundColor(.greyScale2)
                                        if detail.money != 0 {
                                            Text("\(abs(detail.money).formattedString)")
                                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                            +
                                            Text(detail.money > 0 ? "\(currency) 을 받아야해요." : "\(currency) 을 보내야해요")
                                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                        } else {
                                            Text("정산할 금액이 없어요.")
                                                .font(.pretendardFont(.regular, size: scaler.scaleWidth(16)))
                                                .foregroundColor(.greyScale2)
                                        }
                                    }
                                    Spacer()
                                }
                            
                            
                        }
                    }
                    .padding(.horizontal, scaler.scaleWidth(24))
                }
            }
            .padding(.top, scaler.scaleHeight(22))
            
            
            Button {
                applinkManager.generateSettlementLink(settlementId: viewModel.id, bookKey: Keychain.getKeychainValue(forKey: .bookKey) ?? "")
                print(applinkManager.shortenedUrl)
            } label: {
                Text("공유하기")
                    .padding(.bottom, scaler.scaleHeight(10))
                    .frame(maxWidth: .infinity)
                    .frame(height:scaler.scaleHeight(66))
                    .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                    .foregroundColor(.white)
                    .background(Color.primary1)
            }
            .frame(maxWidth: .infinity)
            .frame(height:scaler.scaleHeight(66))
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $applinkManager.showingShareSheet) {
                if let url = applinkManager.shortenedUrl {
                    ActivityView(activityItems: [url])
                }
        }
    }

}

struct CompleteCalcView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteCalcView(isShowingTabbar: .constant(false), isShowingCalc: .constant(true), pageCount: .constant(4), viewModel: CalculateViewModel())
    }
}
