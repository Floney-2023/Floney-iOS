//
//  CalculateMainView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/17.
//

import SwiftUI

struct CalculateMainView: View {
    @Binding var isShowingTabbar : Bool
    @Binding var isShowingCalc : Bool
    @State var isShowingPeriod = false
    @State var pageCount = 1
    @StateObject var viewModel = CalculateViewModel()
    var body: some View {
        ZStack {
            VStack{
                switch pageCount {
                case 1:
                    SetUserCalcView(isShowingTabbar: $isShowingTabbar, isShowingCalc: $isShowingCalc, viewModel: viewModel, pageCount: $pageCount)
                case 2:
                    SetPeriodCalcView(isShowingTabbar: $isShowingTabbar, isShowingCalc: $isShowingCalc, viewModel: viewModel, pageCount: $pageCount)
                case 3:
                    SetContentCalcView(isShowingTabbar: $isShowingTabbar, isShowingCalc: $isShowingCalc, viewModel: viewModel, pageCount: $pageCount)
                case 4:
                    CompleteCalcView(isShowingTabbar: $isShowingTabbar, isShowingCalc: $isShowingCalc, pageCount: $pageCount, viewModel: viewModel)
                default:
                    EmptyView()
                }
            }
            .navigationBarBackButtonHidden()
            .background(Color.red)
            if viewModel.showLoadingView {
                LoadingView()
            }
        }
       
    }
}

struct CalculateMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateMainView(isShowingTabbar: .constant(false), isShowingCalc: .constant(true))
    }
}
