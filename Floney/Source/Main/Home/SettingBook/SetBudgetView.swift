//
//  SetBudgetView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/12.
//

import SwiftUI

struct SetBudgetView: View {
    @StateObject var viewModel = SettingBookViewModel()
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(viewModel.yearlyData[viewModel.selectedYear] ?? [], id: \.month) { monthlyAmount in
                    HStack {
                        Text("\(monthlyAmount.month)월")
                        Spacer()
                        Text("\(monthlyAmount.amount)원")
                    }
                }
            }
        }
    }
}

struct SetBudgetView_Previews: PreviewProvider {
    
    static var previews: some View {
        SetBudgetView()
    }
}
