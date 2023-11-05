//
//  ExpanseView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct ExpenseView: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : AnalysisViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    
    var body: some View {
        VStack(spacing:0){
            HStack(spacing:0){
                VStack(alignment:.leading, spacing: scaler.scaleHeight(8)){
                        Text("총 \(Int(viewModel.expenseResponse.total))\(currency)을\n소비했어요")
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                            .lineSpacing(10)
                            .foregroundColor(.greyScale1)
                            .frame(width: scaler.scaleWidth(236),alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.001)

                        Text("저번 달 대비 \(Int(viewModel.expenseResponse.differance))\(currency)을\n더 사용했어요")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                            .frame(width: scaler.scaleWidth(236),alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.001)
            

                }
           
                VStack {
                    Spacer()
                    Image("expense")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: scaler.scaleWidth(76),height: scaler.scaleHeight(80))
             
                }
                
            }
            .frame(height: scaler.scaleHeight(110))
            .padding(.horizontal, scaler.scaleWidth(4))
            VStack {
                HStack(spacing: 0) {
                    Group {
                        if viewModel.expensePercentage.count != 0 {
                            ForEach(viewModel.expensePercentage.indices, id:\.self) { i in
                                Rectangle()
                                    .fill(viewModel.selectedColors[i])
                                    .frame(width: scaler.scaleWidth(((UIScreen.main.bounds.width - scaler.scaleWidth(40)) * CGFloat(viewModel.expensePercentage[i]) / 100)), height:scaler.scaleHeight(20))
                            }
                        } else {
                            Rectangle()
                                .fill(Color.greyScale10)
                                .frame(maxWidth: .infinity)
                                .frame(height: scaler.scaleHeight(20))
                        }
                    }
                }
                .frame(width: scaler.scaleWidth(320))
                .frame(height: scaler.scaleHeight(20)) // 만약 infinity로 설정 했을 때 : Invalid frame dimension (negative or non-finite).
                .cornerRadius(6)
            }.frame(height: scaler.scaleHeight(76))
            
            if viewModel.expensePercentage.count != 0 {
                VStack(spacing:0) {
                    ScrollView(showsIndicators:false) {
                        VStack(spacing:0) {
                            ForEach(viewModel.expenseResponse.analyzeResult.indices, id: \.self) { i in
                                HStack(spacing:scaler.scaleWidth(12)) {
                                    Rectangle()
                                        .fill(viewModel.selectedColors[i])
                                        .frame(width:scaler.scaleWidth(4), height: scaler.scaleHeight(27))
                                        .cornerRadius(6)
                                    VStack(alignment: .leading, spacing: scaler.scaleHeight(8)) {
                                        Text("\(viewModel.expenseResponse.analyzeResult[i].category)")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                        Text("\(Int(viewModel.expensePercentage[i].rounded()))%")
                                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale5)
                                    }
                                    Spacer()
                                    Text("\(Int(viewModel.expenseResponse.analyzeResult[i].money))\(currency)")
                                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(16)))
                                        .foregroundColor(.greyScale2)
                                }
                                
                                .frame(height:scaler.scaleHeight(68))
                                
                                
                            }
                        }
                        
                    }
                }.padding(.horizontal, scaler.scaleWidth(4))
            } else {
                Spacer()
            
                VStack(spacing:scaler.scaleHeight(12)) {
                    Image("no_line")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:scaler.scaleWidth(50),height:scaler.scaleHeight(84))
                 
                    Text("내역이 없습니다.")
                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(12)))
                        .foregroundColor(.greyScale6)
                    
                }
                .frame(maxHeight: .infinity)
                Spacer()
                  
            }
            
            Spacer()
            
        }
            .onAppear{
                viewModel.analysisExpenseIncome(root: "지출")
            }
            .onChange(of: viewModel.selectedDate) { newValue in
                viewModel.analysisExpenseIncome(root: "지출")
            }
        
    }
   
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView(viewModel: AnalysisViewModel())
    }
}
