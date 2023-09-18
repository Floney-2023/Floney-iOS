//
//  SetcurrencyUnitView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/09.
//

import SwiftUI

struct SetCurrencyUnitView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = SettingBookViewModel()
    @State var showingAlert = false
    @State var title = "가계부가 초기화됩니다"
    @State var message = ""
    @State var selectedUnit = ""
    @State var currencyUnits = ["KRW(원)","USD($)","EUR(€)","JPY(¥)","CNY(¥)","GBP(£)"]
    @State var isSelected = 0
    @State var newCurrency : String = ""

    var body: some View {
        ZStack{
            VStack(spacing: 32){
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("화폐 설정")
                            .font(.pretendardFont(.bold,size:24))
                            .foregroundColor(.greyScale1)
                        Text("찾으시는 화폐 단위가 없나요?\n원하시는 화폐를 플로니에게 알려주세요.")
                            .font(.pretendardFont(.medium,size:13))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                    Image("illust_currency_unit")
                }
                .padding(.horizontal, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(currencyUnits.indices, id:\.self) { index in
                            let parsedCurrency = String(currencyUnits[index].prefix(while: { $0 != "(" })).trimmingCharacters(in: .whitespaces)
                            HStack {
                                
                                Text("\(currencyUnits[index])")
                                    .font(.pretendardFont(.medium,size:12))
                                    .foregroundColor(parsedCurrency == viewModel.currency ? .primary2 : .greyScale6)
                                Spacer()
                                
                                if parsedCurrency == viewModel.currency {
                                    Image("icon_check_circle_activated")
                                        .padding(.trailing, 22)
                                }
                            }
                            .padding(.leading, 22)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(parsedCurrency == viewModel.currency ? Color.primary10 : Color.greyScale12)
                            .cornerRadius(12)
                            .onTapGesture {
                                isSelected = index
                                selectedUnit = currencyUnits[isSelected]
                                newCurrency = String(selectedUnit.prefix(while: { $0 != "(" })).trimmingCharacters(in: .whitespaces)
                                print(parsedCurrency)  // 출력: "KRW"
                                message = "화폐 단위를 \(newCurrency)(으)로 변경하시겠습니까?\n변경 시, 가계부가 초기화됩니다."
                                showingAlert = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 52)
            .customNavigationBar(
                leftView: { BackButton() }
                )
            
            if showingAlert {
                FloneyAlertView(isPresented: $showingAlert, title: $title, message: $message, onOKAction: {
                    viewModel.setCurrency(currency: newCurrency)
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
}




struct SetCurrencyUnitView_Previews: PreviewProvider {
    static var previews: some View {
        SetCurrencyUnitView()
    }
}
