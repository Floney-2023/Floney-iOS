//
//  FirebaseManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/14.
//

import Foundation
import FirebaseStorage
import FirebaseDynamicLinks

class FirebaseManager {
    var encryptionManager = CryptManager()
    // completion: @escaping (URL?) -> Void)
   
    func uploadImageToFirebase(image: UIImage, completion: @escaping (String?) -> Void) {
        // 이 부분에서 Firebase Storage에 이미지를 업로드하는 코드를 작성하고,
        // 이미지의 URL을 completion handler를 통해 반환합니다.
        let timestamp = Date().timeIntervalSince1970
        let imageName = "image\(timestamp)"
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images/\(imageName).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading image: \(error)")
                } else {
                    // 이미지 업로드 성공
                    print("Upload successful")
                    // 이미지 URL 가져오기
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            print("Error getting download URL: \(error)")
                        } else if let url = url {
                            // 이제 url을 사용할 수 있습니다
                            print("Download URL: \(url)")
                            // 키 존재
                            print("original url : \(url.absoluteString)")
                            
                            if let key = self.encryptionManager.key {// 키
                                let encryptedURL = self.encryptionManager.encrypt(url.absoluteString, using: key)
                                print("completed : \(encryptedURL)")
                                let decryptedURL = self.encryptionManager.decrypt(encryptedURL!, using: key)
                                completion(encryptedURL)
                            } else {
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
    
    }
    
}
