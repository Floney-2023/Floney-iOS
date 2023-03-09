//
//  WelcomeView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/08.
//

import SwiftUI

struct WelcomeView: View {
    var pageCount = 3
    var pageCountAll = 3
    @State var nickname = "플로니"
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                    
                    Text("환영합니다\n\(nickname)님!")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("플로니와 함께 똑똑하고 편리한 가계부를\n작성해보세요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                }
                Spacer()
            }
            Spacer()
            
            NavigationLink(destination: WelcomeView()){
                Text("플로니 시작하기")
                    .padding()
                    .modifier(NextButtonModifier())
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
        
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
