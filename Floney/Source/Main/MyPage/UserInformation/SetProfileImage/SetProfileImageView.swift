//
//  SetProfileImageView.swift
//  Floney
//
//  Created by 남경민 on 2023/03/24.
//

import SwiftUI

struct SetProfileImageView: View {
    let scaler = Scaler.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var changedStatus = false
    @State var showAlert = false
    @State var title = "잠깐!"
    @State var message = "수정된 내용이 저장되지 않았습니다.\n그대로 나가시겠습니까?"
    
    @StateObject var viewModel = MyPageViewModel()
    @StateObject var permissionManager = PermissionManager()
    
    var firebaseManager = FirebaseManager()
    //var encryptionManager = CryptManager()
   
    // 이미지선택창 선택 여부
    @State private var presentsImagePicker = false
    // 카메라 선택 여부
    @State private var onCamera = false
    // 사진 앨범 선택 여부
    @State private var onPhotoLibrary = false
    // 프로필 이미지 변화 확정 여부
    @State private var profileChanged = false
    @State private var selectedUIImage: UIImage? = nil {
        didSet {
            self.changedStatus = true
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing:scaler.scaleHeight(20)) {
                if let preview = viewModel.userPreviewImage124 {
                    Image(uiImage: preview)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                        .frame(width:scaler.scaleWidth(124), height: scaler.scaleWidth(124))
                        .overlay(
                            Image("btn_photo_camera")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                .offset(x:scaler.scaleWidth(45),y:scaler.scaleWidth(45))
                        )
                        .onTapGesture {
                            presentsImagePicker = true
                        }
                } else {
                    Image("user_profile_124")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                        .frame(width:scaler.scaleWidth(124), height: scaler.scaleWidth(124))
                        .overlay(
                            Image("btn_photo_camera")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: scaler.scaleWidth(32), height: scaler.scaleWidth(32))
                                .offset(x:scaler.scaleWidth(45),y:scaler.scaleWidth(45))
                        )
                        .onTapGesture {
                            presentsImagePicker = true
                        }
                }
                Text("기본 프로필로 변경")
                    .font(.pretendardFont(.regular, size:scaler.scaleWidth(12)))
                    .foregroundColor(.greyScale6)
                    .onTapGesture {
                        viewModel.randomNumStr = nil
                        viewModel.userPreviewImage124 = UIImage(named: "user_profile_124")
                    }
                Spacer()
                
                Button("변경하기") {
                    LoadingManager.shared.update(showLoading: true, loadingType: .dimmedLoading)
                    if let image = selectedUIImage {
                        print("selected:\(image)")
                        firebaseManager.uploadImageToFirebase(image: image) { url in
                            DispatchQueue.main.async {
                                if let url = url {
                                    self.viewModel.encryptedImageUrl = url // url
                                    print("in book url : \(url)")
                                    print("in book url : \(viewModel.encryptedImageUrl)")
                                    viewModel.changeProfile(imageStatus: "custom") // 서버에 전송
                                    print("in image view: \(url)")
                                }
                            }
                        }
                    } else {
                        if let randomNum = viewModel.randomNumStr {
                            viewModel.changeProfile(imageStatus: "random") // 서버에 전송
                        } else {
                            viewModel.changeProfile(imageStatus: "default") // 서버에 전송
                        }
                    }
                }
                .padding(scaler.scaleWidth(20))
                .font(.pretendardFont(.bold, size:scaler.scaleWidth(14)))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(Color.greyScale2)
                .cornerRadius(12)
            }
            .padding(EdgeInsets(top:scaler.scaleHeight(68), leading: scaler.scaleWidth(20), bottom: 0, trailing: scaler.scaleWidth(20)))
            .customNavigationBar(
                leftView: { BackButtonBlackWithAlert(showAlert: $showAlert, changedStatus : $changedStatus) },
                centerView: { Text("프로필 이미지 변경")
                        .font(.pretendardFont(.semiBold, size:scaler.scaleWidth(16)))
                    .foregroundColor(.greyScale1)}
                
                )
            .onAppear{
                permissionManager.requestCameraPermission()
                permissionManager.requestAlbumPermission()
                viewModel.loadUserPreviewImage()
            }
            // 카메라 선택
            .sheet(isPresented: $onCamera) {
                CameraView(image: $selectedUIImage) { selectedImage in
                    if let selectedImage = selectedImage {
                        self.selectedUIImage = selectedImage
                        viewModel.userPreviewImage124 = selectedImage
                        viewModel.randomNumStr = nil
                    }
                    self.onCamera = false
                }
            }
            // 사진 앨범 선택
            .sheet(isPresented: $onPhotoLibrary) {
                PhotoPicker(image: $selectedUIImage) { selectedImage in
                    if let selectedImage = selectedImage {
                        self.selectedUIImage = selectedImage
                        viewModel.userPreviewImage124 = selectedImage
                        viewModel.randomNumStr = nil
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
                            Text("사진 촬영하기"),
                            action: { onCamera = true }
                        ),
                        .default(
                            Text("앨범에서 사진 선택"),
                            action: { onPhotoLibrary = true }
                        ),
                        .default(
                            Text("랜덤 이미지"),
                            action: {
                                viewModel.setRandomProfileImage()
                            }
                        ),
                        .cancel(
                            Text("취소")
                        )
                    ]
                )
            }
            .onChange(of: viewModel.ChangeProfileImageSuccess) { newValue in
                self.presentationMode.wrappedValue.dismiss()
            }
            //MARK: alert
            if showAlert {
                AlertView(isPresented: $showAlert, title: $title, message: $message) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
           
        }
    }
}

struct SetProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfileImageView()
    }
}
