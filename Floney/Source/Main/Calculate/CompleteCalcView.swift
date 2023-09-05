//
//  CompleteCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI

struct CompleteCalcView: View {
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
                    .padding(.trailing, 24)
                    .onTapGesture {
                        self.isShowingTabbar = true
                        self.isShowingCalc = false
                    }
            }
            VStack(alignment: .leading,spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                            .font(.pretendardFont(.medium, size: 12))
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium, size: 12))
                        
                        
                        Text("정산이")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                            .padding(.top, 11)
                        Text("완료되었어요!")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                        
                    }
                    Spacer()
                    
                    Image("calculate_complete")
                }
                Text("소수점은 반올림되어 계산됩니다.")
                    .font(.pretendardFont(.medium,size: 12))
                    .foregroundColor(.greyScale8)
                HStack {
                    Text("총 지출")
                        .font(.pretendardFont(.medium, size: 16))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Text("\(Int(viewModel.totalOutcome))원")
                        .font(.pretendardFont(.bold, size: 16))
                        .foregroundColor(.greyScale2)
                }
                
                GeometryReader { geometry in
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundColor(.greyScale9)
                }
                .frame(height: 1)
                VStack(spacing: 20) {
                    ForEach(viewModel.details, id:\.self){ detail in
                        HStack {
                            Text("\(detail.userNickname)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                            Text("\(Int((detail.money + viewModel.outcomePerUser)))원")
                                .font(.pretendardFont(.bold, size: 14))
                                .foregroundColor(.greyScale2)
                        }
                    }
                    
                }
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
                        .font(.pretendardFont(.medium, size: 16))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Text("1인")
                        .font(.pretendardFont(.semiBold, size: 10))
                        .foregroundColor(.greyScale6)
                    Text("\(Int(viewModel.outcomePerUser))원")
                        .font(.pretendardFont(.bold, size: 16))
                        .foregroundColor(.primary2)
                }
                
                ForEach(viewModel.details, id: \.self) { detail in
                    HStack{
                        Image("user_profile_32")
                            .clipShape(Circle())
                                .overlay(Circle().stroke(Color.greyScale10, lineWidth: 1))
                        VStack(alignment:.leading) {
                            Text("\(detail.userNickname)")
                                .font(.pretendardFont(.medium, size: 12))
                                .foregroundColor(.greyScale2)
                            if detail.money != 0 {
                                Text("\(Int(abs(detail.money)))")
                                    .font(.pretendardFont(.bold, size: 16))
                                    .foregroundColor(.greyScale2)
                                +
                                Text(detail.money > 0 ? "원 을 받아야해요." : "원 을 보내야해요")
                                    .font(.pretendardFont(.regular, size: 16))
                                    .foregroundColor(.greyScale2)
                            } else {
                                Text("정산할 금액이 없어요.")
                                    .font(.pretendardFont(.regular, size: 16))
                                    .foregroundColor(.greyScale2)
                            }
                        }
                    }
                }
                
                
                  
                       
             Spacer()
            }
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            HStack(spacing:0){
                Text("공유하기")
                    .padding(.bottom, 10)
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(Color.primary1)
            }.frame(height:UIScreen.main.bounds.height * 0.085)
                .onTapGesture {
                    applinkManager.generateSettlementLink(settlementId: viewModel.id, bookKey: Keychain.getKeychainValue(forKey: .bookKey)!)
                    if let url = applinkManager.shortenedUrl {
                        self.onShareSheet = true
                    }
                }
            
        }.edgesIgnoringSafeArea(.bottom)
            .sheet(isPresented: $onShareSheet) {
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
