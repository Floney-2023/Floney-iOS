//
//  SetContentCalc.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI

struct SetContentCalcView: View {
    @Binding var isShowingCalc : Bool
    @Binding var isShowingPeriod : Bool
    @Binding var isShowingContent : Bool
    @State var isShowingComplete = false
    var pageCount = 3
    var pageCountAll = 4
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image("icon_close")
                    .padding(.trailing, 24)
                    .onTapGesture {
                        self.isShowingCalc = false
                    }
            }
            VStack(spacing: 32) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                            .font(.pretendardFont(.medium, size: 12))
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium, size: 12))
                        
                        
                        Text("정산할 내역을")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                            .padding(.top, 11)
                        Text("선택해주세요")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                    }
                    Spacer()
                }
                
                
             Spacer()
            }
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            HStack(spacing:0){
                
                Text("이전으로")
                    .padding()
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.greyScale2)
                    .onTapGesture {
                        self.isShowingContent = false
                    }
                Text("다음으로")
                    .padding()
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(width: UIScreen.main.bounds.width * 2/3)
                    .background(Color.primary1)
                    .onTapGesture {
                        self.isShowingComplete = true
                    }
            }
            
        }
        .fullScreenCover(isPresented: $isShowingComplete) {
            CompleteCalcView(isShowingCalc: $isShowingCalc)
        }

    }

}

struct SetContentCalcView_Previews: PreviewProvider {
    static var previews: some View {
        SetContentCalcView(isShowingCalc: .constant(true), isShowingPeriod: .constant(true), isShowingContent: .constant(true))
    }
}
