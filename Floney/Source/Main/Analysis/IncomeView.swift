//
//  IncomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/11.
//

import SwiftUI

struct IncomeView: View {
    @ObservedObject var viewModel : AnalysisViewModel
    
    let percentage = [40, 40, 20]
    
    var body: some View {
        VStack(){
            VStack(alignment:.leading, spacing: 0){
                Text("총 1,000,000원을")
                    .font(.pretendardFont(.bold,size: 22))
                    .foregroundColor(.greyScale1)
                HStack{
                    VStack(alignment:.leading, spacing: 10) {
                        Text("벌었어요")
                            .font(.pretendardFont(.bold,size: 22))
                            .foregroundColor(.greyScale1)
                        Text("저번 달 대비 1,000,000원을\n더 벌었어요")
                            .font(.pretendardFont(.medium,size: 13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                    Image("expense")
                }
            }
            
            HStack(spacing: 0) {
                ForEach(0..<percentage.count) { i in
                    Rectangle()
                        .fill(viewModel.incomeSelectedColors[i])
                        .frame(width: ((UIScreen.main.bounds.width - 40)*CGFloat(percentage[i]) / 100), height: 20)
                }
            }
            .frame(width: .infinity, height: 20)
            .cornerRadius(6)
            .padding(.vertical, 20)
            
            ForEach(0..<viewModel.incomes.count) { i in
                HStack {
                    Rectangle()
                        .fill(viewModel.incomeSelectedColors[i])
                        .frame(width: 4, height: 27)
                        .cornerRadius(6)
                    VStack(alignment: .leading) {
                        Text("\(viewModel.incomes[i].content)")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Text("\(viewModel.incomes[i].percentage)%")
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale5)
                    }
                    Spacer()
                    Text("\(Int(viewModel.incomes[i].money))원")
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale2)
                }.frame(height: 68)
            }
            
            Spacer()
        }.padding(.horizontal,24)
        
    }
}

struct IncomeView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeView(viewModel: AnalysisViewModel())
    }
}
