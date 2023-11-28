//
//  SetcurrencyUnitView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/09.
//

import SwiftUI

struct SetCurrencyUnitView: View {
    let scaler = Scaler.shared
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
            VStack(spacing:scaler.scaleHeight(32)){
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        Text("화폐 설정")
                            .font(.pretendardFont(.bold,size:scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                        Text("찾으시는 화폐 단위가 없나요?\n원하시는 화폐를 플로니에게 알려주세요.")
                            .lineSpacing(4)
                            .font(.pretendardFont(.medium,size:scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                    }
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width:scaler.scaleWidth(86), height:scaler.scaleHeight(76))
                        .background(
                            Image("illust_monetary_unit")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width:scaler.scaleWidth(86), height:scaler.scaleHeight(76))
                      
                        )
                }
                .padding(.horizontal, scaler.scaleWidth(24))
                
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(currencyUnits.indices, id:\.self) { index in
                            let parsedCurrency = String(currencyUnits[index].prefix(while: { $0 != "(" })).trimmingCharacters(in: .whitespaces)
                            HStack {
                                
                                Text("\(currencyUnits[index])")
                                    .font(parsedCurrency == viewModel.currency ? .pretendardFont(.bold,size:scaler.scaleWidth(12)) : .pretendardFont(.medium,size:scaler.scaleWidth(12)))
                                    .foregroundColor(parsedCurrency == viewModel.currency ? .primary2 : .greyScale6)
                                Spacer()
                                
                                if parsedCurrency == viewModel.currency {
                                    Image("icon_check_circle_activated")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: scaler.scaleWidth(24), height: scaler.scaleWidth(24))
                                 
                                        .padding(.trailing, scaler.scaleWidth(16))
                                }
                            }
                            .padding(.leading, scaler.scaleWidth(22))
                            //.padding(.vertical, scaler.scaleHeight(21))
                            .frame(maxWidth: .infinity)
                            .frame(height:scaler.scaleHeight(54))
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
                .padding(.horizontal, scaler.scaleWidth(20))
            }
            .padding(.top,scaler.scaleHeight(52))
            .customNavigationBar(
                leftView: { BackButton() }
                )
            
            if showingAlert {
                FloneyAlertView(isPresented: $showingAlert, title: $title, message: $message, onOKAction: {
                    LoadingManager.shared.update(showLoading: true, loadingType: .floneyLoading)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        LoadingManager.shared.update(showLoading: false, loadingType: .floneyLoading)
                        viewModel.setCurrency(currency: newCurrency)
                        self.presentationMode.wrappedValue.dismiss()
                    }
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
