//
//  SetBookProfileImageView.swift
//  Floney
//
//  Created by 남경민 on 2023/05/30.
//

import SwiftUI
import CryptoKit
import FirebaseStorage

struct SetBookProfileImageView: View {
    @StateObject var viewModel = SettingBookViewModel()
    @StateObject var permissionManager = PermissionManager()
    var firebaseManager = FirebaseManager()
    var encryptionManager = CryptManager()
    // 프로필 이미지
    @State var bookProfileImage: Image = Image("btn_book_profile")
    // 이미지선택창 선택 여부
    @State private var presentsImagePicker = false
    // 카메라 선택 여부
    @State private var onCamera = false
    // 사진 앨범 선택 여부
    @State private var onPhotoLibrary = false
    // 프로필 이미지 변화 확정 여부
    @State private var profileChanged = false
    @State private var selectedUIImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing:20) {
           bookProfileImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                .frame(width: 124, height: 124)
                .overlay(
                    Image("btn_photo_camera")
                        .offset(x:45,y:45)
                )
                .onTapGesture {
                    presentsImagePicker = true
                }
            Text("기본 프로필로 변경")
                .font(.pretendardFont(.regular, size: 12))
                .foregroundColor(.greyScale6)
                .onTapGesture {
                    bookProfileImage = Image("btn_book_profile")
                }
            Spacer()
            
            Button("변경하기") {
                if let image = selectedUIImage {
                    firebaseManager.uploadImageToFirebase(image: image) { encryptedURL in
                        DispatchQueue.main.async {
                            if let url = encryptedURL {
                                viewModel.encryptedImageUrl = url
                                viewModel.changeProfile()
                                print("in image view: \(url)")
                            }
                        }
                    }
                }
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
        .onAppear{
         permissionManager.requestCameraPermission()
         permissionManager.requestAlbumPermission()
         }
        // 카메라 선택
        .sheet(isPresented: $onCamera) {
            CameraView(image: $selectedUIImage) { selectedImage in
                if let selectedImage = selectedImage {
                    self.selectedUIImage = selectedImage
                    self.bookProfileImage = Image(uiImage: selectedImage)
                }
                self.onCamera = false
            }
        }
        // 사진 앨범 선택
        .sheet(isPresented: $onPhotoLibrary) {
            PhotoPicker(image: $selectedUIImage) { selectedImage in
                if let selectedImage = selectedImage {
                    self.selectedUIImage = selectedImage
                    self.bookProfileImage = Image(uiImage: selectedImage)
                }
                self.onPhotoLibrary = false
            }
        }
        .actionSheet(isPresented: $presentsImagePicker) {
            ActionSheet(
                title: Text("이미지 선택하기"),
                message: nil,
                buttons: [
                    .default(
                        Text("카메라"),
                        action: { onCamera = true }
                    ),
                    .default(
                        Text("사진 앨범"),
                        action: { onPhotoLibrary = true }
                    ),
                    .cancel(
                        Text("돌아가기")
                    )
                ]
            )
        }
        
    }
    
    
}

struct SetBookProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SetBookProfileImageView()
    }
}
