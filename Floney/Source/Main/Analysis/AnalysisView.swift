//
//  AnalysisView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI
enum ButtonOptions: String, CaseIterable {
    case optionOne = "지출"
    case optionTwo = "수입"
    case optionThree = "예산"
    case optionFour = "자산"
}

struct AnalysisView: View {
    let scaler = Scaler.shared
    @Binding var showingTabbar : Bool

    var options = ["지출", "수입", "예산", "자산"]
    @State private var selectedOptions = 0
    @State private var selectedOption = ButtonOptions.optionOne
    @StateObject var viewModel = AnalysisViewModel()
    @State var isShowingPicker = false
    
    var body: some View {
        ZStack{
            VStack(spacing:scaler.scaleHeight(20)){
                HStack {
                    Text("분석")
                        .font(.pretendardFont(.bold, size: scaler.scaleWidth(22)))
                        .foregroundColor(.greyScale1)
                    Spacer()
                    Image("icon_arrow_left")
                        .onTapGesture {
                            viewModel.moveBackward()
                        }
                    Text("\(viewModel.selectedMonth)월")
                        .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(20)))
                        .foregroundColor(.greyScale1)
                        .onTapGesture {
                            showingTabbar = false
                            isShowingPicker = true
                        }
                    Image("icon_arrow_right")
                        .onTapGesture {
                            viewModel.moveForward()
                        }
                }
                .background(Color.red)
                .padding(.horizontal, scaler.scaleWidth(20))
                .padding(.bottom, scaler.scaleHeight(10))
                
                HStack(spacing: 0) {
                    ForEach(options.indices, id:\.self) { index in
                        ZStack {
                            Rectangle()
                                .fill(Color.greyScale12)
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(6)
                                .padding(scaler.scaleWidth(4))
                                .opacity(selectedOptions == index ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring()) {
                                        selectedOptions = index
                                    }
                                }
                        }
                        .overlay(
                            Text(options[index])
                                .font(.pretendardFont(.semiBold, size: scaler.scaleWidth(14)))
                                .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                        )
                    }
                }
                .frame(height: scaler.scaleHeight(38))
                .cornerRadius(8)
                .padding(.horizontal, scaler.scaleWidth(20))
                
                VStack {
                    switch selectedOptions {
                    case 0:
                        ExpenseView(viewModel: viewModel)
                    case 1:
                        IncomeView(viewModel: viewModel)
                    case 2:
                        BudgetView(showingTabbar : $showingTabbar,viewModel: viewModel)
                    case 3:
                        AssetView(viewModel: viewModel)
                    default:
                        ExpenseView(viewModel: viewModel)
                    }
                }
                .padding(.horizontal, scaler.scaleWidth(20))
                
                Spacer()
                
            }
            .padding(.top,scaler.scaleHeight(26))
            .onChange(of: LoadingManager.shared.showLoading) { newValue in
                    LoadingManager.shared.showLoading = newValue
                }
            .onAppear {
                    showingTabbar = true
            }

            
            PickerBottomSheet(availableChangeTabbarStatus : true, showingTab: $showingTabbar, isShowing: $isShowingPicker, yearMonth: $viewModel.yearMonth)

        }
    }
   
}



struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(showingTabbar: .constant(true))
    }
}
