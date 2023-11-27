//
//  IncomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct IncomeView: View {
    let scaler = Scaler.shared
    @ObservedObject var viewModel : AnalysisViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    
    var body: some View {
        VStack(spacing:0){
            HStack(spacing:0){
                VStack(alignment:.leading, spacing: scaler.scaleHeight(8)){
                    Text("총 \(viewModel.incomeResponse.total.formattedString)\(currency)을\n벌었어요")
                        .font(.pretendardFont(.bold,size:scaler.scaleWidth(22)))
                        .lineSpacing(10)
                        .foregroundColor(.greyScale1)
                        .frame(width: scaler.scaleWidth(236),alignment: .leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.001)
                    if viewModel.incomeResponse.differance < 0 {
                        Text("저번 달 대비 \(abs(viewModel.incomeResponse.differance).formattedString)\(currency)을\n적게 벌었어요")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                            .frame(width: scaler.scaleWidth(236),alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.001)
                    } else {
                        Text("저번 달 대비 \(viewModel.incomeResponse.differance.formattedString)\(currency)을\n더 벌었어요")
                            .font(.pretendardFont(.medium,size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                            .frame(width: scaler.scaleWidth(236),alignment: .leading)
                            .lineLimit(2)
                            .minimumScaleFactor(0.001)
                    }
                    
                }
                VStack {
                    Spacer()
                    Image("income")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: scaler.scaleWidth(76),height: scaler.scaleWidth(76))
             
                }
                   
            }
            .frame(height: scaler.scaleHeight(110))
            .padding(.horizontal, scaler.scaleWidth(4))

            VStack {
                HStack(spacing: 0) {
                    Group {
                        if viewModel.incomePercentage.count != 0 {
                            ForEach(viewModel.incomePercentage.indices, id:\.self) { i in
                                Rectangle()
                                    .fill(viewModel.incomeSelectedColors[i])
                                    .frame(width: scaler.scaleWidth(((UIScreen.main.bounds.width - scaler.scaleWidth(40)) * CGFloat(viewModel.incomePercentage[i]) / 100)), height:scaler.scaleHeight(20))
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
            }
            .frame(height: scaler.scaleHeight(76))
 
        
            if viewModel.incomePercentage.count != 0 {
                VStack(spacing:0) {
                    ScrollView(showsIndicators:false) {
                        VStack(spacing:0) {
                            ForEach(viewModel.incomeResponse.analyzeResult.indices, id: \.self) { i in
                                HStack(spacing:scaler.scaleWidth(12)) {
                                    Rectangle()
                                        .fill(viewModel.incomeSelectedColors[i])
                                        .frame(width:scaler.scaleWidth(4), height: scaler.scaleHeight(27))
                                        .cornerRadius(6)
                                    VStack(alignment: .leading, spacing: scaler.scaleHeight(8)) {
                                        Text("\(viewModel.incomeResponse.analyzeResult[i].category)")
                                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale2)
                                        Text("\(Int(viewModel.incomePercentage[i].rounded()))%")
                                            .font(.pretendardFont(.regular, size: scaler.scaleWidth(14)))
                                            .foregroundColor(.greyScale5)
                                    }
                                    Spacer()
                                    Text("\(viewModel.incomeResponse.analyzeResult[i].money.formattedString)\(currency)")
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
                    Image("no_line_2")
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
                viewModel.analysisExpenseIncome(root: "수입")
            }
            .onChange(of: viewModel.selectedDate) { newValue in
                viewModel.analysisExpenseIncome(root: "수입")
            }
    }
}

struct IncomeView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeView(viewModel: AnalysisViewModel())
    }
}
