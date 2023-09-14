//
//  CryptManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/14.
//

import Foundation
import CryptoKit
import Combine


//MARK: 암호화 매니저
class CryptManager : ObservableObject {
    @Published var key : SymmetricKey?
    
    init(key: SymmetricKey? = nil) {
        self.key = key
        /*
        guard let keyData = Keychain.getDataTypeKey(forKey: .encryptionKey) else {
            self.setEncryptionKey()
            self.key = self.keyDataToSymmetricKey()
            //print("encryption key : \(self.key)")
            return
        }
        self.key = keyDataToSymmetricKey()
        //print("encryption key : \(self.key)")*/
    }
    //MARK: key string
    func setEncryptionKey() {
        // 암호화할 때 사용할 키, 이 키를 이용해서 url을 암호화하고 복호화함.
        let keyData = Data((0..<32).map { _ in return UInt8.random(in: 0...255) })
        //Keychain.setDataTypeKey(keyData, forKey: .encryptionKey)
        print(keyData.base64EncodedString())
    }
    //MARK: key string 을 symmetricKey로 변환
    func keyDataToSymmetricKey() -> SymmetricKey? {
        var key : SymmetricKey?
        /*
        if let keyData = Keychain.getDataTypeKey(forKey: .encryptionKey) {
            key = SymmetricKey(data: keyData)
            print(key)
        }*/
        return key
    }
    
    // 암호화 함수
    func encrypt(_ string: String, using key: SymmetricKey) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        guard let sealedBox = try? AES.GCM.seal(data, using: key) else { return nil }
        print(sealedBox.combined?.base64EncodedString())
        return sealedBox.combined?.base64EncodedString()
    }

    // 복호화 함수
    func decrypt(_ string: String, using key: SymmetricKey) -> String? {
        print("암호화한 url : \(string)")
        guard let data = Data(base64Encoded: string) else {
            print(string)
            print("암호화한 url, 데이터로 인코딩 실패")
            return nil
        }
        guard let sealedBox = try? AES.GCM.SealedBox(combined: data) else {
            print("암호화한 data, sealedBox로 로딩 실패")
            return nil
            
        }
        guard let originalData = try? AES.GCM.open(sealedBox, using: key) else {
            print("암호화한 sealedbox, original data로 로딩 실패")
            return nil
            
        }
        print("오리지널 데이터 : ")
        print(String(data: originalData, encoding: .utf8))
        return String(data: originalData, encoding: .utf8)
    }
}
