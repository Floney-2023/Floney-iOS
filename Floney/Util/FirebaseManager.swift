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
                            if Keychain.getDataTypeKey(forKey: .encryptionKey) == nil {
                                self.encryptionManager.setEncryptionKey()
                            }
                            if let key = self.encryptionManager.keyDataToSymmetricKey() {// 키 변환
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
    
    func createDynamicLink(for bookCode: String) -> URL? {
        // URL에 bookCode 쿼리 파라미터를 추가합니다.
        var finalUrl = URL(string: "")
        let link = URL(string: "https://floney.page.link?bookCode=\(bookCode)")!
        let dynamicLinksDomainURIPrefix = "https://floney.page.link" // Firebase 콘솔에서 제공되는 값으로 변경하세요

        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)

        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.KyoungminNam.Floney") // 앱의 번들 ID로 변경하세요
        //linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.yourapp.android") // 안드로이드 앱의 패키지 이름으로 변경하세요
        linkBuilder!.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        linkBuilder!.socialMetaTagParameters?.title = "플로니 Floney"
        linkBuilder!.socialMetaTagParameters?.imageURL = URL(string: "")


        // 이 URL을 공유합니다
        let longLink = linkBuilder?.url
        print("The long URL is: \(longLink)")

        // 짧은 URL을 만들어서 공유하는 것이 좋습니다
        linkBuilder?.shorten { (shortURL, warnings, error) in
            if let error = error {
                print("Error: \(error)")
            }
            if let warnings = warnings {
                for warning in warnings {
                    print("Warning: \(warning)")
                }
            }
            if let shortURL = shortURL {
                print("The short URL is: \(shortURL)")
                finalUrl = shortURL
            }
        }
        return finalUrl
    }
}
