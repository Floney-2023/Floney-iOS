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
                Text("총 1,000,000원을")
                    .font(.pretendardFont(.bold,size: 22))
                    .foregroundColor(.greyScale1)
                HStack{
                    VStack(alignment:.leading, spacing: 10) {
                        Text("소비했어요")
                            .font(.pretendardFont(.bold,size: 22))
                            .foregroundColor(.greyScale1)
                        Text("저번 달 대비 1,000,000원을\n더 사용했어요")
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
                        .fill(viewModel.selectedColors[i])
                        .frame(width: ((UIScreen.main.bounds.width - 40)*CGFloat(percentage[i]) / 100), height: 20)
                }
            }
            .frame(width: .infinity, height: 20)
            .cornerRadius(6)
            .padding(.vertical, 20)
            
            ForEach(0..<viewModel.expenses.count) { i in
                HStack {
                    Rectangle()
                        .fill(viewModel.selectedColors[i])
                        .frame(width: 4, height: 27)
                        .cornerRadius(6)
                    VStack(alignment: .leading) {
                        Text("\(viewModel.expenses[i].content)")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                        Text("\(viewModel.expenses[i].percentage)%")
                            .font(.pretendardFont(.regular, size: 14))
                            .foregroundColor(.greyScale5)
                    }
                    Spacer()
                    Text("\(Int(viewModel.expenses[i].money))원")
                        .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale2)
                }.frame(height: 68)
            }
            
            Spacer()
        }.padding(.horizontal,24)
        
    }
   
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView(viewModel: AnalysisViewModel())
    }
}
