//
//  CryptManager.swift
//  Floney
//
//  Created by 남경민 on 2023/06/14.
//

import Foundation
import CryptoKit

class CryptManager {
    func setEncryptionKey() {
        // 암호화할 때 사용할 키, 이 키를 이용해서 url을 암호화하고 복호화함.
        let keyData = Data((0..<32).map { _ in return UInt8.random(in: 0...255) })
        Keychain.setDataTypeKey(keyData, forKey: .encryptionKey)
        print(keyData.base64EncodedString())
    }
    
    func keyDataToSymmetricKey() -> SymmetricKey? {
        var key : SymmetricKey?
        if let keyData = Keychain.getDataTypeKey(forKey: .encryptionKey) {
            key = SymmetricKey(data: keyData)
            print(key)
        }
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
        guard let data = Data(base64Encoded: string) else { return nil }
        guard let sealedBox = try? AES.GCM.SealedBox(combined: data) else { return nil }
        guard let originalData = try? AES.GCM.open(sealedBox, using: key) else { return nil }
        print(String(data: originalData, encoding: .utf8))
        return String(data: originalData, encoding: .utf8)
    }
}
