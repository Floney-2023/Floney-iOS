//
//  SetBudgetView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/12.
//

import SwiftUI

struct SetBudgetView: View {
    @State private var showingSheet = false
    @StateObject var viewModel = SettingBookViewModel()
    @State var setBudgetBottonSheet = false
    @State var month = 0
    var body: some View {
        ZStack {
        ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            showingSheet = true
                        } label: {
                            HStack(spacing:0) {
                                Text("\(String(viewModel.selectedYear))")
                                    .font(.pretendardFont(.medium, size: 13))
                                    .foregroundColor(.black)
                                    .padding(.leading,12)
                                    .padding(.top, 7)
                                    .padding(.bottom,8)
                                Image("icon_set_year_arrow")
                                    .padding(.trailing,8)
                                    .padding(.top, 6)
                                    .padding(.bottom,6)
                                
                            }
                            .background(Color.white)
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.greyScale9, lineWidth: 1)
                            )
                        }
                    }.padding(.horizontal,20)
                        .padding(.bottom, 17)
                    VStack(spacing: 12) {
                        ForEach(viewModel.yearlyData[viewModel.selectedYear] ?? [], id: \.month) { monthlyAmount in
                            HStack {
                                Text("\(monthlyAmount.month)월")
                                Spacer()
                                Text("\(monthlyAmount.amount.formattedString)원")
                                
                            }
                            .padding(20)
                            .frame(height: UIScreen.main.bounds.height * 0.069)
                            .font(.pretendardFont(.bold, size:12))
                            .foregroundColor(monthlyAmount.amount > 0 ? .primary2 : .greyScale6)
                            .background(monthlyAmount.amount > 0 ? Color.primary10 : Color.greyScale12)
                            .cornerRadius(12)
                            .onTapGesture {
                                month = monthlyAmount.month
                                viewModel.setBudgetDate(month: monthlyAmount.month)
                                setBudgetBottonSheet = true
                            }
                            
                        }
                    }.padding(.horizontal, 20)
                }
                .customNavigationBar(
                    leftView: { BackButtonBlack() },
                    centerView: { Text("예산 설정")
                            .font(.pretendardFont(.semiBold, size: 16))
                        .foregroundColor(.greyScale1)}
                    )
            }
            YearBottomSheet(selectedYear: $viewModel.selectedYear, isShowing: $showingSheet)
            SetBudgetBottomSheet(isShowing: $setBudgetBottonSheet, month: $month, viewModel: viewModel)
            
        }
    }
}

struct SetBudgetView_Previews: PreviewProvider {
    
    static var previews: some View {
        SetBudgetView()
    }
}
