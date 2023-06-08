//
//  SetBookProfileImageView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI

struct SetBookProfileImageView: View {
    @State private var openPhoto = false
    @State private var image = UIImage()
    var body: some View {
        VStack(spacing:20) {
            Image("btn_book_profile")
                .overlay(
                    Image("btn_photo_camera")
                        .offset(x:45,y:45)
                )
            Text("기본 프로필로 변경")
                .font(.pretendardFont(.regular, size: 12))
                .foregroundColor(.greyScale6)
            Spacer()
            
            Button("변경하기") {
                
            }
            .padding(20)
            .font(.pretendardFont(.bold, size: 14))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.greyScale2)
            .cornerRadius(12)
            
 
        }
        .padding(EdgeInsets(top: 68, leading: 20, bottom: 0, trailing: 20))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonBlack())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("프로필 이미지 변경")
                    .font(.pretendardFont(.semiBold, size: 16))
                    .foregroundColor(.greyScale1)
            }
        }
        .sheet(isPresented: $openPhoto) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }

    }
}

struct SetBookProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SetBookProfileImageView()
    }
}
