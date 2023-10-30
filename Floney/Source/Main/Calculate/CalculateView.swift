//
//  CalculateView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct CalculateView: View {
    let scaler = Scaler.shared
    var date = 11
    @State var isShowingCalc = false
    @Binding var settlementId : Int
    @Binding var isShowingSettlement : Bool
    @Binding var showingTabbar : Bool
    @Binding var showingDetail : Bool
    @StateObject var viewModel = CalculateViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("정산")
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                        .foregroundColor(.greyScale1)
                    Spacer()
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(34))
                
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(12)) {
                        Text("마지막 정산일로부터\n\(viewModel.passedDays)일 지났어요")
                            .lineSpacing(5)
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                            .foregroundColor(.greyScale1)

                        Text("복잡하고 어려운 정산, 저희가 대신 해드릴게요")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                }
                .padding(.horizontal, scaler.scaleWidth(20))

                Image("calculate")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: scaler.scaleWidth(360))
                    .frame(height: scaler.scaleHeight(320))
                    .padding(.bottom, scaler.scaleHeight(26))


                Button {
                    self.isShowingCalc = true
                } label: {
                    Text("정산하기")
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                .frame(height: scaler.scaleHeight(46))
                .modifier(NextButtonModifier(backgroundColor: .primary1))
                .padding(.bottom, scaler.scaleHeight(18))
                
                
                VStack(spacing:0) {
                    Text("정산 내역 보기")
                        .font(.pretendardFont(.regular, size: scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale6)
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: scaler.scaleWidth(70), height: scaler.scaleWidth(0.5))
                      .background(Color.greyScale6)
                    
                }
                .onTapGesture {
                    self.isShowingSettlement = true
                }
                
                Spacer()
                
                NavigationLink(destination : CalculateMainView(isShowingTabbar: $showingTabbar, isShowingCalc: $isShowingCalc), isActive: $isShowingCalc){
                    EmptyView()
                }
                NavigationLink(destination : SettlementListView(isShowing: $isShowingSettlement, showingTabbar: $showingTabbar, settlementId: $settlementId, showingDetail: $showingDetail), isActive: $isShowingSettlement){
                    EmptyView()
                }
            }
            .padding(.top,scaler.scaleHeight(26))
            
            .onAppear{
                    viewModel.getPassedDays()
                    showingTabbar = true
            }
            
        }
    }
}

struct CalculateView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateView(settlementId: .constant(0), isShowingSettlement: .constant(false), showingTabbar: .constant(true), showingDetail: .constant(false))
    }
}
