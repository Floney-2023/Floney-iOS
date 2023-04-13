//
//  CreateBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/13.
//

import SwiftUI

struct CreateBookView: View {
    var pageCount = 1
    var pageCountAll = 4
    var body: some View {
        VStack(spacing: 32) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                    
                    Text("가계부 추가하기")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("언제든지 멤버를 추가할 수 있는\n플로니의 가계부를 만들어 보세요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
           
            
            Spacer()
            
            NavigationLink(destination: EmailAuthView()){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct CreateBookView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBookView()
    }
}
