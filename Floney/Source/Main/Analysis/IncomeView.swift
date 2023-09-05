//
//  IncomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct IncomeView: View {
    @ObservedObject var viewModel : AnalysisViewModel
    @State var currency = CurrencyManager.shared.currentCurrency
    let percentage = [40, 40, 20]
    
    var body: some View {
        VStack(){
            VStack(alignment:.leading, spacing: 0){
                Text("총 \(Int(viewModel.incomeResponse.total))\(currency)을")
                    .font(.pretendardFont(.bold,size: 22))
                    .foregroundColor(.greyScale1)
                HStack{
                    VStack(alignment:.leading, spacing: 10) {
                        Text("벌었어요")
                            .font(.pretendardFont(.bold,size: 22))
                            .foregroundColor(.greyScale1)
                        Text("저번 달 대비 \(Int(viewModel.incomeResponse.differance))\(currency)을\n더 벌었어요")
                            .font(.pretendardFont(.medium,size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                    Image("income")
                }
            }
            
            HStack(spacing: 0) {
                if viewModel.incomePercentage.count != 0 {
                    ForEach(viewModel.incomePercentage.indices, id:\.self) { i in
                        Rectangle()
                            .fill(viewModel.incomeSelectedColors[i])
                            .frame(width: ((UIScreen.main.bounds.width - 40)*CGFloat(viewModel.incomePercentage[i]) / 100), height: 20)
                    }
                } else {
                    Rectangle()
                        .fill(Color.greyScale10)
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                }
            }
            .cornerRadius(6)
            .padding(.vertical, 20)
        
            if viewModel.incomePercentage.count != 0 {
                ScrollView(showsIndicators:false) {
                    ForEach(viewModel.incomeResponse.analyzeResult.indices, id:\.self) { i in
                        HStack {
                            Rectangle()
                                .fill(viewModel.incomeSelectedColors[i])
                                .frame(width: 4, height: 27)
                                .cornerRadius(6)
                            VStack(alignment: .leading) {
                                Text("\(viewModel.incomeResponse.analyzeResult[i].category)")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale2)
                                Text("\(Int(viewModel.incomePercentage[i].rounded()))%")
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale5)
                            }
                            Spacer()
                            Text("\(Int(viewModel.incomeResponse.analyzeResult[i].money))\(currency)")
                                .font(.pretendardFont(.semiBold, size: 16))
                                .foregroundColor(.greyScale2)
                        }.frame(height: 68)
                    }
                }
            } else {
                Image("img_budget_0")
                    .padding(.top, 100)
            }
            
            Spacer()
            
        }//.padding(.horizontal,24)
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
