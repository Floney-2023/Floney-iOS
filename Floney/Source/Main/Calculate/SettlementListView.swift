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
    @State var showingDetail = false
    @StateObject var viewModel = CalculateViewModel()
    var body: some View {
        VStack(spacing:28) {
            HStack {
                Spacer()
                Text("정산 내역")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
                Spacer()
                Image("icon_close")
                    .onTapGesture {
                        showingTabbar = true
                        isShowing = false
                    }
            }.padding(.bottom,6)
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
                    ForEach(0..<1, id:\.self) { list in
                        VStack(spacing: 12) {
                            VStack(spacing:22) {
                                HStack {
                                    Text("기간")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale6)
                                    Spacer()
                                    Text("2022.10.10 - 10.25")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale2)
                                    
                                }
                                HStack {
                                    Text("총 금액")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale6)
                                    Spacer()
                                    Text("300,000원")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale2)
                                    
                                }
                                HStack {
                                    Text("인원")
                                        .font(.pretendardFont(.medium,size: 13))
                                        .foregroundColor(.greyScale6)
                                    Spacer()
                                    Text("2명")
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
                                Text("150,000원")
                                    .font(.pretendardFont(.bold, size: 16))
                                    .foregroundColor(.primary2)
                                Image("forward_button")
                                    .padding(.leading, 8)
                                
                            }
                            .padding(20)
                            .background(Color.primary10)
                            .cornerRadius(12)
                        }.onTapGesture {
                            showingDetail = true
                        }
                    }
                }
           // }
        
        }
        .padding(.horizontal, 20)
        .onAppear{
            showingTabbar = false
            //viewModel.getSettlementList()
        }
        .navigationBarBackButtonHidden()
        
       // NavigationLink(destina)
    }
}

struct SettlementListView_Previews: PreviewProvider {
    static var previews: some View {
        SettlementListView(isShowing: .constant(true), showingTabbar: .constant(false))
    }
}
