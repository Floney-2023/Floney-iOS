//
//  ExpanseView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel : AnalysisViewModel
    
    let percentage = [40, 40, 20]
    
    var body: some View {
        VStack(){
            VStack(alignment:.leading, spacing: 0){
                Text("총 \(Int(viewModel.expenseResponse.total))원을")
                    .font(.pretendardFont(.bold,size: 22))
                    .foregroundColor(.greyScale1)
                HStack{
                    VStack(alignment:.leading, spacing: 10) {
                        Text("소비했어요")
                            .font(.pretendardFont(.bold,size: 22))
                            .foregroundColor(.greyScale1)
                        Text("저번 달 대비 \(Int(viewModel.expenseResponse.differance))원을\n더 사용했어요")
                            .font(.pretendardFont(.medium,size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                    Image("expense")
                }
            }
            
            HStack(spacing: 0) {
                if viewModel.expensePercentage.count != 0 {
                    ForEach(viewModel.expensePercentage.indices, id:\.self) { i in
                        Rectangle()
                            .fill(viewModel.selectedColors[i])
                            .frame(width: ((UIScreen.main.bounds.width - 40)*CGFloat(viewModel.expensePercentage[i]) / 100), height: 20)
                    }
                } else {
                    Rectangle()
                        .fill(Color.greyScale10)
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                }
            }
            .frame(height: 20) // 만약 infinity로 설정 했을 때 : Invalid frame dimension (negative or non-finite).
            .cornerRadius(6)
            .padding(.vertical, 20)
            
            if viewModel.expensePercentage.count != 0 {
                ScrollView(showsIndicators:false) {
                    ForEach(viewModel.expenseResponse.analyzeResult.indices, id: \.self) { i in
                        HStack {
                            Rectangle()
                                .fill(viewModel.selectedColors[i])
                                .frame(width: 4, height: 27)
                                .cornerRadius(6)
                            VStack(alignment: .leading) {
                                Text("\(viewModel.expenseResponse.analyzeResult[i].category)")
                                    .font(.pretendardFont(.medium, size: 14))
                                    .foregroundColor(.greyScale2)
                                Text("\(Int(viewModel.expensePercentage[i].rounded()))%")
                                    .font(.pretendardFont(.regular, size: 14))
                                    .foregroundColor(.greyScale5)
                            }
                            Spacer()
                            Text("\(Int(viewModel.expenseResponse.analyzeResult[i].money))원")
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
            
        }.padding(.horizontal,24)
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
