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
    @Binding var createBookType : createBookType
    @ObservedObject var viewModel : CreateBookViewModel
    @StateObject var permissionManager = PermissionManager()
    var firebaseManager = FirebaseManager()
    @State var bookImg = ""
    
    // 이미지선택창 선택 여부
    @State private var presentsImagePicker = false
    // 카메라 선택 여부
    @State private var onCamera = false
    // 사진 앨범 선택 여부
    @State private var onPhotoLibrary = false
    @State private var selectedUIImage: UIImage? = UIImage(named: "book_profile_124")
    
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
                    
                    Image(uiImage: selectedUIImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle()) // 프로필 이미지를 원형으로 자르기
                        .frame(width: 124, height: 124)
                        .overlay(
                            Image("btn_photo_camera")
                                .offset(x:45,y:45)
                        )
                        .padding(.top, 32)
                        .onTapGesture {
                            presentsImagePicker = true
                        }
                }
                Spacer()
            }
            
            Spacer()
            
            NavigationLink(destination: CreateBookView(), isActive: $viewModel.isNextToCreateBook){
                Text("다음으로")
                    .padding()
                    .withNextButtonFormmating(.primary1)
                    .onTapGesture {
                        LoadingManager.shared.update(showLoading: true, loadingType: .dimmedLoading)
                        if let image = selectedUIImage {
                            print("selectedUIImage있음 ")
                            if image == UIImage(named: "book_profile_124") {
                                print("기본 이미지임")
                                print("book name : \(viewModel.bookName)")
                                if !viewModel.bookName.isEmpty {
                                    print("북 생성")
                                    if createBookType == .initial {
                                        viewModel.createBook()
                                    } else {
                                        viewModel.addBook()
                                    }
                                }
                            } else {
                                firebaseManager.uploadImageToFirebase(image: image) { encryptedURL in
                                    DispatchQueue.main.async {
                                        if let url = encryptedURL {
                                            viewModel.profileImg = url
                                            if !viewModel.bookName.isEmpty {
                                                if createBookType == .initial {
                                                    viewModel.createBook()
                                                } else {
                                                    viewModel.addBook()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                           
                        }
                    }
            }
        }
        .onAppear{
            permissionManager.requestCameraPermission()
            permissionManager.requestAlbumPermission()
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 0, trailing: 24))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonBlack())
        //MARK: action sheet
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
                    .cancel(
                        Text("취소")
                    )
                ]
            )
        }
        // 카메라 선택
        .sheet(isPresented: $onCamera) {
            CameraView(image: $selectedUIImage) { selectedImage in
                if let selectedImage = selectedImage {
                    self.selectedUIImage = selectedImage
                }
                self.onCamera = false
            }
        }
        // 사진 앨범 선택
        .sheet(isPresented: $onPhotoLibrary) {
            PhotoPicker(image: $selectedUIImage) { selectedImage in
                if let selectedImage = selectedImage {
                    self.selectedUIImage = selectedImage
                }
                self.onPhotoLibrary = false
            }
        }

    }
}

struct SetBookProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SetBookProfileView(createBookType: .constant(.initial), viewModel: CreateBookViewModel())
    }
}
