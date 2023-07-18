//
//  SettlementDetailView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/18.
//

import SwiftUI

struct SettlementDetailView: View {
    @Binding var isShowingTabbar : Bool
    @Binding var showingDetail : Bool
    @ObservedObject var viewModel : CalculateViewModel
    var body: some View {
        VStack {
            /*
            HStack {
                Image("back_button")
                    .onTapGesture {
                        print("back button tapped")
                        self.showingDetail = false
                    }
                Spacer()
                
            }
            .padding(.vertical, 22)
            .padding(.leading, 20)*/

            VStack(alignment: .leading,spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(viewModel.startDateStr) - \(viewModel.endDateStr)")
                            .foregroundColor(.greyScale7)
                            .font(.pretendardFont(.medium, size: 14))

                        Text("정산 영수증")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                    }
                    Spacer()
                }
                .padding(.horizontal,24)
    
                HStack {
                    Text("총 지출")
                        .font(.pretendardFont(.medium, size: 16))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Text("\(viewModel.totalOutcome)원")
                        .font(.pretendardFont(.bold, size: 16))
                        .foregroundColor(.greyScale2)
                }.padding(.horizontal, 28)
                
                GeometryReader { geometry in
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundColor(.greyScale9)
                }
                .frame(height: 1)
                .padding(.horizontal,24)
                VStack(spacing: 20) {
                    ForEach(viewModel.details, id:\.self){ detail in
                        HStack {
                            Text("\(detail.userNickname)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale6)
                            Spacer()
                            Text("\(detail.money + viewModel.outcomePerUser)")
                                .font(.pretendardFont(.medium, size: 14))
                                .foregroundColor(.greyScale2)
                        }
                    }
                }.padding(.horizontal, 28)
                GeometryReader { geometry in
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundColor(.greyScale9)
                }
                .frame(height: 1)
                .padding(.horizontal,24)
                HStack {
                    Text("정산 금액")
                        .font(.pretendardFont(.medium, size: 16))
                        .foregroundColor(.greyScale2)
                    Spacer()
                    Text("1인")
                        .font(.pretendardFont(.semiBold, size: 10))
                        .foregroundColor(.greyScale6)
                    Text("\(viewModel.outcomePerUser)원")
                        .font(.pretendardFont(.bold, size: 16))
                        .foregroundColor(.primary2)
                }
                .padding(.horizontal,28)
                
                
                Divider()
                    .frame(height: 4)
                    .background(Color.background2)
                    
                    ForEach(viewModel.details, id: \.self) { detail in
                        HStack(spacing: 11){
                            Image("icon_profile")
                            VStack(alignment:.leading, spacing: 8) {
                                Text("\(detail.userNickname)")
                                    .font(.pretendardFont(.medium, size: 12))
                                    .foregroundColor(.greyScale2)
                                if detail.money != 0 {
                                    Text("\(abs(detail.money))")
                                        .font(.pretendardFont(.bold, size: 16))
                                        .foregroundColor(.greyScale2)
                                    +
                                    Text(detail.money > 0 ? " 을 받아야해요." : " 을 보내야해요")
                                        .font(.pretendardFont(.regular, size: 16))
                                        .foregroundColor(.greyScale2)
                                } else {
                                    Text("정산할 금액이 없어요.")
                                        .font(.pretendardFont(.regular, size: 16))
                                        .foregroundColor(.greyScale2)
                                }
                            }
                        }
                        .padding(.leading, 24)
                    }
       
             Spacer()
            }
            //.padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            HStack(spacing:0){

                Text("공유하기")
                    .padding()
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    .background(Color.primary1)
            }
            
        }.navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton())
            .onAppear{
                viewModel.getSettlementDetail()
            }

    }
}

struct SettlementDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementDetailView(isShowingTabbar: .constant(false), showingDetail: .constant(true), viewModel: CalculateViewModel())
    }
}
