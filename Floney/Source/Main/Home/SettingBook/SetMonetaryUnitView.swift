//
//  SetMonetaryUnitView.swift
//  Floney
//
//  Created by 남경민 on 2023/08/09.
//

import SwiftUI

struct SetMonetaryUnitView: View {
    @State var showingAlert = false
    @State var title = "모든 내역이 사라집니다"
    @State var message = ""
    @State var selectedUnit = ""
    @State var monetaryUnits = ["KRW(원)","USD($)","EUR(€)","JPY(¥)","CNY(¥)","GBP(£)"]
    @State var isSelected = 0
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
                    Image("illust_monetary_unit")
                }
                .padding(.horizontal, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(monetaryUnits.indices, id:\.self) { index in
                            HStack {
                                Text("\(monetaryUnits[index])")
                                    .font(.pretendardFont(.medium,size:12))
                                    .foregroundColor(isSelected == index ? .primary2 : .greyScale6)
                                Spacer()
                                Image(isSelected == index ? "icon_check_circle_activated" : "icon_check_circle_disabled")
                                    .padding(.trailing, 22)
                            }
                            .padding(.leading, 22)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(isSelected == index ? Color.primary10 : Color.greyScale12)
                            .cornerRadius(12)
                            .onTapGesture {
                                isSelected = index
                                selectedUnit = monetaryUnits[isSelected]
                                message = "화폐 단위를 \(selectedUnit)(으)로 변경하시겠습니까?\n변경 시, 기록된 전체 내역이 초기화됩니다."
                                showingAlert = true
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 52)
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: BackButton())
            
            if showingAlert {
                FloneyAlertView(isPresented: $showingAlert, title: $title, message: $message, onOKAction: {})
            }
        }
    }
}




struct SetMonetaryUnitView_Previews: PreviewProvider {
    static var previews: some View {
        SetMonetaryUnitView()
    }
}
