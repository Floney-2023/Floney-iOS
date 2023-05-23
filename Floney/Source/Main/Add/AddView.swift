//
//  AddView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/09.
//

import SwiftUI

struct AddView: View {
    @State var money : String = ""
    @State private var selectedView: Int = 1

    var body: some View {
        @State var moneyStr = String(describing: "\(money)")
        VStack {
            VStack(spacing: 32){
                VStack {
                    HStack {
                        Text("금액")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale6)
                        Spacer()
                    }
                    HStack {
                        TextField("금액을 입력하세요", text: $money)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.primary2)
                            .font(.pretendardFont(.bold, size: 36))
                        Text("원")
                            .foregroundColor(.primary2)
                            .font(.pretendardFont(.bold, size: 36))
                    }
                }
                HStack {
                    Button(action: {
                        selectedView = 1
                    }) {
                        Text("지출")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(selectedView == 1 ? Color.white : Color.greyScale10)
                    .foregroundColor(selectedView == 1 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(8)
                    
                    Button(action: {
                        selectedView = 2
                    }) {
                        Text("수입")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(selectedView == 2 ? Color.white : Color.greyScale10)
                    .foregroundColor(selectedView == 2 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(8)
                    
                    Button(action: {
                        selectedView = 3
                    }) {
                        Text("이체")
                            .font(.pretendardFont(.semiBold, size: 11))
                    }
                    //.frame(width: 54, height: 24)
                    .padding(10)
                    .background(selectedView == 3 ? Color.white : Color.greyScale10)
                    .foregroundColor(selectedView == 3 ? Color.greyScale2 : Color.greyScale8)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .background(Color.greyScale10)
                .cornerRadius(10)
                VStack(spacing:44) {
                    HStack {
                        Text("날짜")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale4)
                        Spacer()
                        Text("2022.10.20")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                    }
                    HStack {
                        Text("자산")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale4)
                        Spacer()
                        //MARK: 눌렀을 때 bottom sheet
                        Text("현금")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                    }
                    HStack {
                        Text("분류")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale4)
                        Spacer()
                        Text("분류를 선택하세요.")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                    }
                    HStack {
                        Text("내용")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale4)
                        Spacer()
                        Text("점심")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                    }
                    HStack {
                        Text("예산에서 제외")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale4)
                        Spacer()
                        Text("ㅡㅡ")
                            .font(.pretendardFont(.medium, size: 14))
                            .foregroundColor(.greyScale2)
                    }
                }
                // Spacer()
                
            }
            .padding(20)
            Spacer()
            HStack(spacing:0) {
                Button {
                    //
                } label: {
                    Text("삭제")
                    
                        .font(.pretendardFont(.bold, size:14))
                        .foregroundColor(.white)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.greyScale2)
                Button {
                    //
                } label: {
                    Text("저장하기")
                        .font(.pretendardFont(.bold, size:14))
                    
                        .foregroundColor(.white)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary1)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 66)
            
            
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
