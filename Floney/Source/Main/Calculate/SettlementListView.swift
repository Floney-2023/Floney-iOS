//
//  SettlementListView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/18.
//

import SwiftUI

struct SettlementListView: View {
    @Binding var isShowing : Bool
    @Binding var showingTabbar : Bool
    @Binding var settlementId : Int
    @Binding var showingDetail :Bool
    @StateObject var viewModel = CalculateViewModel()
    @State var currency = CurrencyManager.shared.currentCurrency
    var body: some View {
        VStack(spacing:28) {
            ZStack {
                HStack {
                    Spacer()
                    Image("icon_close")
                        .padding(.trailing, 20)
                        .onTapGesture {
                            showingTabbar = true
                            isShowing = false
                        }
                    
                }
                Text("정산 내역")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
                
            }.padding(.top, 18)
            .padding(.bottom,10)
            /*
            if viewModel.settlementList.count == 0 {
                VStack {
                    Image("no_line")
                    Text("정산 내역이 없습니다.")
                        .font(.pretendardFont(.medium,size: 12))
                        .foregroundColor(.greyScale6)
                }.padding(.bottom,100)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            } else {*/
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.settlementList, id:\.self) { list in
                        VStack(spacing: 12) {
                            VStack(spacing:22) {
                                HStack {
                                    Text("기간")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale6)
                                    Spacer()
                                    Text("\(list.startDate) - \(list.endDate)")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale2)
                                    
                                }
                                HStack {
                                    Text("총 금액")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale6)
                                    Spacer()
                                    Text("\(Int(list.totalOutcome))\(currency)")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale2)
                                    
                                }
                                HStack {
                                    Text("인원")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale6)
                                    Spacer()
                                    Text("\(list.userCount)명")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale2)
                                    
                                }
                            }
                            .padding(20)
                            .background(Color.greyScale12)
                            .cornerRadius(12)
                            HStack {
                                Text("정산 금액")
                                    .font(.pretendardFont(.semiBold,size: 13))
                                    .foregroundColor(.greyScale2)
                                Spacer()
                                Text("1인")
                                    .font(.pretendardFont(.semiBold, size: 10))
                                    .foregroundColor(.greyScale6)
                                Text("\(Int(list.outcome))\(currency)")
                                    .font(.pretendardFont(.bold, size: 16))
                                    .foregroundColor(.primary2)
                                Image("forward_button")
                                    .padding(.leading, 8)
                                
                            }
                            .padding(20)
                            .background(Color.primary10)
                            .cornerRadius(12)
                        }.onTapGesture {
                            settlementId = list.id
                            viewModel.id = settlementId
                            showingDetail = true
                        }
                    }
                }
           // }
        
        }
        .padding(.horizontal, 20)
        .onAppear{
            showingTabbar = false
            viewModel.getSettlementList()
        }
        .navigationBarBackButtonHidden()
        
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

