//
//  SetBookProfile.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import SwiftUI

struct SetBookProfileView: View {
    var pageCount = 2
    var pageCountAll = 3
    //@State var bookTitle = ""
    @StateObject var viewModel = CreateBookViewModel()
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("\(pageCount)")
                        .foregroundColor(.greyScale2)
                    + Text(" / \(pageCountAll)")
                        .foregroundColor(.greyScale6)
                    
                    Text("가계부 프로필 설정하기")
                        .font(.pretendardFont(.bold, size: 24))
                        .foregroundColor(.greyScale1)
                    Text("사진을 설정하여 나만의 가계부를\n만들어 보세요.")
                        .font(.pretendardFont(.medium, size: 13))
                        .foregroundColor(.greyScale6)
                    Image("btn_book_profile")
                        .overlay(
                            Image("btn_photo_camera")
                                .offset(x:45,y:45)
                        )
                        .padding(.top, 32)
                }
                
                Spacer()
            }
            
            Spacer()
            
            NavigationLink(destination: CreateBookView()){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                /*
                    .onTapGesture {
                        viewModel.createBook()
                    }
                 */
            }
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct SetBookProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetBookProfileView()
    }
}
