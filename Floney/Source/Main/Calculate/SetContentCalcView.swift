//
//  SetContentCalc.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI

struct SetContentCalcView: View {
    let scaler = Scaler.shared
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
    @State var currency = CurrencyManager.shared.currentCurrency
    @ObservedObject var viewModel : CalculateViewModel
    /*
    @State var list : [SettlementResponse] = [
        SettlementResponse(money: 6000, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "Cake", userEmail: "", img: nil, isSelected: true),
        SettlementResponse(money: 4500, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "커피",userEmail: "", img: nil, isSelected: false),
        SettlementResponse(money: 6000, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "Cake", userEmail: "", img: nil, isSelected: true),
        SettlementResponse(money: 4500, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "커피",userEmail: "", img: nil, isSelected: false),
        SettlementResponse(money: 6000, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "Cake", userEmail: "", img: nil, isSelected: true),
        SettlementResponse(money: 4500, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "커피",userEmail: "", img: nil, isSelected: false),
        SettlementResponse(money: 6000, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "Cake", userEmail: "", img: nil, isSelected: true),
        SettlementResponse(money: 4500, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "커피",userEmail: "", img: nil, isSelected: false),
        SettlementResponse(money: 6000, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "Cake", userEmail: "", img: nil, isSelected: true),
        SettlementResponse(money: 4500, category: ["체크카드","카페/간식"], assetType: "OUTCOME", content: "커피",userEmail: "", img: nil, isSelected: false)
        
    ]*/
    @Binding var pageCount : Int
    var pageCountAll = 4
    
    var body: some View {
        
        ZStack{
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
                VStack(spacing:scaler.scaleHeight(24)) {
                    HStack {
                        VStack(alignment: .leading, spacing: scaler.scaleHeight(5)) {
                            Text("\(pageCount)")
                                .foregroundColor(.greyScale2)
                                .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                            + Text(" / \(pageCountAll)")
                                .foregroundColor(.greyScale6)
                                .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                            
                            
                            Text("정산할 내역을")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                                .foregroundColor(.greyScale1)
                                .padding(.top, scaler.scaleHeight(11))
                            Text("선택해주세요")
                                .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                                .foregroundColor(.greyScale1)
                        }
                        Spacer()
                    }
                    .padding(.leading, scaler.scaleWidth(4))
                    
                    HStack {
                        Spacer()
                        Text("전체선택")
                            .font(.pretendardFont(.regular,size: scaler.scaleWidth(12)))
                            .foregroundColor(.greyScale8)
                            .onTapGesture {
                                self.selectAllItems()
                            }
                    }
                    VStack {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(viewModel.lines.indices, id: \.self) { index in
                                    HStack(spacing: scaler.scaleWidth(12)) {
                                        if viewModel.lines[index].isSelected! {
                                            Image("icon_check_circle_activated")
                                               // .padding(.bottom, scaler.scaleHeight(15))
                                        }
                                        else {
                                            Image("icon_check_circle_disabled")
                                               // .padding(.bottom, scaler.scaleHeight(15))
                                        }
                                        VStack(spacing:0) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: scaler.scaleHeight(10)) {
                                                    Text("\(viewModel.lines[index].content)")
                                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                                        .foregroundColor(.greyScale2)
                                                    Text("\(viewModel.lines[index].category[0]) ‧ \(viewModel.lines[index].category[1])")
                                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                                                        .foregroundColor(.greyScale6)
                                                }
                                                Spacer()
                                                Text("\(Int(viewModel.lines[index].money))\(currency)")
                                                    .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                                    .foregroundColor(.greyScale2)
                                            }
                                            .padding(.vertical, scaler.scaleHeight(18))
                                            Divider()
                                        }
                                    }
                                    //.frame(height:scaler.scaleHeight(53))
                                    //.background(Color.red)
                                    .onTapGesture {
                                        viewModel.lines[index].isSelected?.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top:scaler.scaleHeight(22), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
                
                HStack(spacing:0){
                    
                    Text("이전으로")
                        .padding(.bottom,scaler.scaleHeight(10))
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .background(Color.greyScale2)
                        .onTapGesture {
                            pageCount = 2
                        }
                    Text("정산하기")
                        .padding(.bottom,scaler.scaleHeight(10))
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(14)))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .frame(width: UIScreen.main.bounds.width * 2/3)
                        .background(Color.primary1)
                        .onTapGesture {
                            viewModel.CheckOutcome()
                            if viewModel.outcomeRequest.isEmpty {
                                AlertManager.shared.update(showAlert: true, message: "정산할 내역을 선택해주세요.", buttonType: .red)
                            } else {
                                viewModel.postSettlements()
                                pageCount = 4
                            }
                        }
                }
                .frame(height: scaler.scaleHeight(66))
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                
            }
            
        }
        
    }
    
    func selectAllItems() {
        for index in viewModel.lines.indices {
            viewModel.lines[index].isSelected = true
        }
    }
    
}

struct SetContentCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetContentCalcView(isShowingTabbar: .constant(false), isShowingCalc: .constant(true),viewModel: CalculateViewModel(), pageCount: .constant(3))
    }
}
