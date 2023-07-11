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
    var options = ["지출", "수입", "예산", "자산"]
    @State private var selectedOptions = 0
    @State private var selectedOption = ButtonOptions.optionOne
    @StateObject var viewModel = AnalysisViewModel()
    init(){
            
        }
    var body: some View {
        ZStack{
            VStack(spacing:24){
                
                HStack {
                    Text("분석")
                        .font(.pretendardFont(.bold, size: 22))
                        .foregroundColor(.greyScale1)
                    
                    Spacer()
                    Image("leftSide")
                    Text("11월")
                        .font(.pretendardFont(.semiBold, size: 20))
                        .foregroundColor(.greyScale1)
                    Image("rightSide")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                /*
                Picker("Options", selection: $selectedOption) {
                    ForEach(ButtonOptions.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                            .font(.pretendardFont(.semiBold, size: 14))
                            .foregroundColor(.greyScale2)
                    }
                }
               
                .pickerStyle(SegmentedPickerStyle())
                .padding()*/
                HStack(spacing: 0) {
                    ForEach(options.indices, id:\.self) { index in
                        ZStack {
                            Rectangle()
                                .fill(Color.greyScale12)
                            Rectangle()
                                .fill(Color.white)
                                .cornerRadius(6)
                                .padding(4)
                                .opacity(selectedOptions == index ? 1 : 0.01)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring()) {
                                        selectedOptions = index
                                    }
                                }
                        }
                        .overlay(
                            Text(options[index])
                                .font(.pretendardFont(.semiBold, size: 14))
                                .foregroundColor(selectedOptions == index ? .greyScale2: .greyScale8)
                        )
                    }
                }
                .frame(height: 38)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                
                switch selectedOptions {
                case 0:
                    ExpenseView(viewModel: viewModel)
                case 1:
                    IncomeView(viewModel: viewModel)
                case 2:
                    BudgetView()
                case 3:
                    AssetView()
                default:
                    ExpenseView(viewModel: viewModel)
                }
                
                Spacer()
                
            }.padding(.top, 26)
            
            
        }
    }
}



struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
    }
}
