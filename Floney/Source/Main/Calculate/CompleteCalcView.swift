//
//  CompleteCalcView.swift
//  Floney
//
//  Created by 남경민 on 2023/07/05.
//

import SwiftUI

struct CompleteCalcView: View {
    @Binding var isShowingCalc : Bool
  
    var pageCount = 4
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
                        
                        
                        Text("정산이")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                            .padding(.top, 11)
                        Text("완료되었어요!")
                            .font(.pretendardFont(.bold, size: 22))
                            .foregroundColor(.greyScale1)
                    }
                    Spacer()
                }
                
                
             Spacer()
            }
            .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
            HStack(spacing:0){

                Text("공유하기")
                    .padding()
                    .font(.pretendardFont(.bold, size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    .background(Color.primary1)
            }
            
        }

    }

}

struct CompleteCalcView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteCalcView(isShowingCalc: .constant(true))
    }
}
