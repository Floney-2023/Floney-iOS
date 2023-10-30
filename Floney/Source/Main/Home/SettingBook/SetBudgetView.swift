//
//  SetBudgetView.swift
//  Floney
//
//  Created by 남경민 on 2023/09/12.
//

import SwiftUI

struct SetBudgetView: View {
    let scaler = Scaler.shared
    @State private var showingSheet = false
    @StateObject var viewModel = SettingBookViewModel()
    @State var setBudgetBottonSheet = false
    @State var month = 0
    var body: some View {
        ZStack {
            VStack{
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                showingSheet = true
                            } label: {
                                HStack(spacing:0) {
                                    Text("\(String(viewModel.selectedYear))")
                                        .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                                        .foregroundColor(.black)
                                        .padding(.leading, scaler.scaleWidth(12))
                                        .padding(.top,scaler.scaleHeight(7))
                                        .padding(.bottom,scaler.scaleHeight(8))
                                    Image("icon_set_year_arrow")
                                        .padding(.trailing,scaler.scaleWidth(8))
                                        .padding(.top, scaler.scaleHeight(6))
                                        .padding(.bottom,scaler.scaleHeight(6))
                                    
                                }
                                .background(Color.white)
                                .cornerRadius(50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.greyScale9, lineWidth: 1)
                                )
                            }
                        }.padding(.horizontal,scaler.scaleWidth(20))
                            .padding(.bottom, scaler.scaleHeight(17))
                            .padding(.top, scaler.scaleHeight(2))
                        VStack(spacing: scaler.scaleHeight(12)) {
                            ForEach(viewModel.yearlyData[viewModel.selectedYear] ?? [], id: \.month) { monthlyAmount in
                                HStack {
                                    Text("\(monthlyAmount.month)월")
                                    Spacer()
                                    Text("\(monthlyAmount.amount.formattedString)원")
                                }
                                .padding(scaler.scaleWidth(20))
                                .padding(.horizontal,scaler.scaleWidth(2))
                                .frame(height: scaler.scaleHeight(54))
                                .font(.pretendardFont(.bold, size:scaler.scaleWidth(12)))
                                .foregroundColor(monthlyAmount.amount > 0 ? .primary2 : .greyScale6)
                                .background(monthlyAmount.amount > 0 ? Color.primary10 : Color.greyScale12)
                                .cornerRadius(12)
                                .onTapGesture {
                                    month = monthlyAmount.month
                                    viewModel.setBudgetDate(month: monthlyAmount.month)
                                    setBudgetBottonSheet = true
                                }
                                
                            }
                        }.padding(.horizontal, scaler.scaleWidth(20))
                    } 
                }
            }
            
            .customNavigationBar(
                leftView: { BackButtonBlack() },
                centerView: { Text("예산 설정")
                        .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)}
            )
            .onAppear {
                viewModel.getBudget()
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
