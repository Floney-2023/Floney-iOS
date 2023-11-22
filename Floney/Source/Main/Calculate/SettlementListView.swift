//
//  SettlementListView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/18.
//

import SwiftUI

struct SettlementListView: View {
    let scaler = Scaler.shared
    @Binding var isShowing : Bool
    @Binding var showingTabbar : Bool
    @Binding var settlementId : Int
    @Binding var showingDetail :Bool
    @StateObject var viewModel = CalculateViewModel()
    @State var currency = CurrencyManager.shared.currentCurrency
    var body: some View {
        VStack {
            Group {
                if viewModel.settlementList.count == 0 {
                    VStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width:scaler.scaleWidth(50), height:scaler.scaleHeight(84))
                            .background(
                                Image("no_line")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:scaler.scaleWidth(50), height:scaler.scaleHeight(84))
                      
                            )
                        Text("정산 내역이 없습니다.")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale6)
                        
                    }
                    .padding(.bottom,scaler.scaleHeight(100))
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing:scaler.scaleHeight(28)) {
                            ForEach(viewModel.settlementList, id:\.self) { list in
                                VStack(spacing: scaler.scaleHeight(12)) {
                                    VStack(spacing:scaler.scaleHeight(22)) {
                                        HStack {
                                            Text("기간")
                                                .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                                .foregroundColor(.greyScale6)
                                            Spacer()
                                            Text("\(list.startDate) - \(list.endDate)")
                                                .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                                .foregroundColor(.greyScale2)
                                            
                                        }
                                        HStack {
                                            Text("총 금액")
                                                .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                                .foregroundColor(.greyScale6)
                                            Spacer()
                                            Text("\(list.totalOutcome.formattedString)\(currency)")
                                                .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                                .foregroundColor(.greyScale2)
                                            
                                        }
                                        HStack {
                                            Text("인원")
                                                .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                                .foregroundColor(.greyScale6)
                                            Spacer()
                                            Text("\(list.userCount)명")
                                                .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                                                .foregroundColor(.greyScale2)
                                            
                                        }
                                    }
                                    .padding(scaler.scaleWidth(20))
                                    .background(Color.greyScale12)
                                    .cornerRadius(12)
                                    HStack {
                                        Text("정산 금액")
                                            .font(.pretendardFont(.semiBold,size: scaler.scaleWidth(13)))
                                            .foregroundColor(.greyScale2)
                                        Spacer()
                                        Text("1인")
                                            .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(10)))
                                            .foregroundColor(.greyScale6)
                                        Text("\(list.outcome.formattedString)\(currency)")
                                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(16)))
                                            .foregroundColor(.primary2)
                                        Image("forward_button")
                                            .padding(.leading, scaler.scaleWidth(8))
                                        
                                    }
                                    .padding(.leading,scaler.scaleWidth(20))
                                    .padding(.vertical,scaler.scaleWidth(21))
                                    .padding(.trailing,scaler.scaleWidth(8))
                                    .background(Color.primary10)
                                    .cornerRadius(12)
                                } // VStack
                                .onTapGesture {
                                    settlementId = list.id
                                    viewModel.id = settlementId
                                    showingDetail = true
                                }
                            } //Foreach
                        }
                    } // Scroll
                } // else
            } // Group
        } // VStack
        .padding(.horizontal, scaler.scaleWidth(20))
        .onAppear{
            showingTabbar = false
            viewModel.getSettlementList()
            print("Settlement List View : 정산 리스트 보여주나요 ? :\(isShowing)")
            print("Settlement List View : 정산 디테일도 보여주나요 ? :\(showingDetail)")
        }
        .customNavigationBar(
            centerView: {
                Text("정산 내역")
                    .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)
            },
            rightView: {
                Image("icon_close")
                    .onTapGesture {
                        showingTabbar = true
                        isShowing = false
                    }
            }
        )
        NavigationLink(destination: SettlementDetailView(isShowingTabbar: $showingTabbar, showingDetail: $showingDetail, settlementId: $settlementId, viewModel: viewModel), isActive: $showingDetail) {
            EmptyView()
        }
    }
}


struct SettlementListView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementListView(isShowing: .constant(true), showingTabbar: .constant(false), settlementId: .constant(0), showingDetail: .constant(false))
    }
}

