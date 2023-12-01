//
//  CreateBookView.swift
//  Floney
//
//  Created by 남경민 on 2023/04/18.
//

import SwiftUI
import UIKit

struct CreateBookView: View {
    let scaler = Scaler.shared
    var pageCount = 3
    var pageCountAll = 3
    @Binding var createBookType : createBookType
    @State var isShowingBottomSheet = false
    @State var onShareSheet = false
    @StateObject var viewModel = SettingBookViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: scaler.scaleHeight(16)) {
                        Text("\(pageCount)")
                            .foregroundColor(.greyScale2)
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        + Text(" / \(pageCountAll)")
                            .foregroundColor(.greyScale6)
                            .font(.pretendardFont(.medium, size:scaler.scaleWidth(12)))
                        
                        Text("가계부가 생성되었어요!")
                            .font(.pretendardFont(.bold, size: scaler.scaleWidth(24)))
                            .foregroundColor(.greyScale1)
                        Text("간편하고 쉬운 가계부, 플로니와 함께 해요")
                            .font(.pretendardFont(.medium, size: scaler.scaleWidth(13)))
                            .foregroundColor(.greyScale6)
                        
                    }
                    Spacer()
                }
                .padding(.leading, scaler.scaleWidth(24))
                Spacer()
                Image("book_illust")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:scaler.scaleWidth(360), height: scaler.scaleWidth(360))
             
                    
                Spacer()
                
                VStack(spacing: scaler.scaleHeight(12)) {
                    
                    Text("작성하러 가기")
                        .padding(scaler.scaleHeight(16))
                        .withNextButtonFormmating(.primary1)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                //if createBookType == .add {
                                //BookExistenceViewModel.shared.bookExistence = false
                                //}
                                AuthenticationService.shared.newMainTab.toggle()
                                BookExistenceViewModel.shared.getBookExistence()
                            }
                        }
                    
                    Text("친구 초대하기")
                        .padding(scaler.scaleHeight(16))
                        .foregroundColor(.primary1)
                        .withNextButtonFormmating(.primary9)
                        .onTapGesture {
                            self.isShowingBottomSheet.toggle()
                        }
                }
            }
            .sheet(isPresented: $onShareSheet) {
                if let url = viewModel.shareUrl {
                    ActivityView(activityItems: [url])
                }
               
            }
            .navigationBarBackButtonHidden(true)
            .padding(EdgeInsets(top:scaler.scaleHeight(78), leading: scaler.scaleWidth(24), bottom: scaler.scaleHeight(40), trailing: scaler.scaleWidth(24)))
            .edgesIgnoringSafeArea(.bottom)
            
            ShareBookBottomSheet(viewModel: viewModel, isShowing: $isShowingBottomSheet, onShareSheet: $onShareSheet)
        }
    }
}

struct CreateBookView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBookView(createBookType:.constant(createBookType.add))
    }
}
